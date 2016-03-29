//
//  Chanel.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/18/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import Foundation
import Alamofire
import HTMLReader

let URLString = "http://www.vtvcab.vn/lich-phat-song"

class Chanel : NSObject, NSCoding {
    var channelId: String!
    var schedule: [Show]?
    var name: String?
    var source: String?
    var image: UIImage?
    
    init(channelId: String) {
        self.channelId = channelId
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey("channelId") as! String
        let name = aDecoder.decodeObjectForKey("name") as? String
        let source = aDecoder.decodeObjectForKey("source") as? String
        let image = aDecoder.decodeObjectForKey("image") as? UIImage
        self.init(channelId: id)
        self.name = name
        self.source = source
        self.image = image
    }
    
    convenience init(dict: NSDictionary) {
        let id = dict.objectForKey("channelId") as! String
        self.init(channelId: id)
        self.name = dict.objectForKey("name") as? String
        self.source = dict.objectForKey("source") as? String
        if let imageName = dict.objectForKey("image") as? String {
            self.image = UIImage(named: imageName)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(channelId, forKey: "channelId")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(source, forKey: "source")
        aCoder.encodeObject(image, forKey: "image")
        
    }
    
    private func parseHTMLRow(rowElement: HTMLElement) -> Show? {
        var name: String?
        var time: String?
        var additional: String?
        
        //first column: show time
        if let firstColumn = rowElement.childAtIndex(1) as? HTMLElement {
            time = firstColumn.textContent
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                .stringByReplacingOccurrencesOfString("\n", withString: "")
        }
        
        //second column: show name
        if let secondColumn = rowElement.childAtIndex(3) as? HTMLElement {
            name = secondColumn.textContent
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                .stringByReplacingOccurrencesOfString("\n", withString: "")
        }
        
        //Third column: show additional info
        if let thirdColumn = rowElement.childAtIndex(5) as? HTMLElement {
            additional = thirdColumn.textContent
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                .stringByReplacingOccurrencesOfString("\n", withString: "")
        }
        
        if let name = name, time = time {
            return Show(name: name, time: time, additional: additional)
        }
        
        return nil
    }
    
    private func isScheduleTable(tableElement: HTMLElement) -> Bool {
        if let firstChild = tableElement.firstNodeMatchingSelector("thead") {
            let lowerCaseContent = firstChild.textContent.lowercaseString
            if lowerCaseContent.containsString("thời gian") && lowerCaseContent.containsString("tên chương trình") && lowerCaseContent.containsString("chi tiết") {
                return true
            }
        }
        return false
    }
    
    func fetchSchedule(day: String, month: String, year: String, completionHandler: (NSError?) -> Void) {
        Alamofire.request(.GET, URLString, parameters : [
            "day" : day,
            "month" : month,
            "year" : year,
            "channel" : self.channelId
            ])
            .responseString { responseString in
                guard responseString.result.error == nil else {
                    completionHandler(responseString.result.error!)
                    return
                    
                }
                guard let htmlAsString = responseString.result.value else {
                    let error = Error.errorWithCode(.StringSerializationFailed, failureReason: "Could not get HTML as String")
                    completionHandler(error)
                    return
                }
                
                let doc = HTMLDocument(string: htmlAsString)
                
                // find the table of charts in the HTML
                let tables = doc.nodesMatchingSelector("table")
                var scheduleTable:HTMLElement?
                for table in tables {
                    if let tableElement = table as? HTMLElement {
                        if self.isScheduleTable(tableElement) {
                            scheduleTable = tableElement
                            break
                        }
                    }
                }
                
                // make sure we found the table of schedule
                guard let tableContents = scheduleTable else {
                    // TODO: create error
                    let error = Error.errorWithCode(.DataSerializationFailed, failureReason: "Could not find schedule table in HTML document")
                    completionHandler(error)
                    return
                }
                
                self.schedule = []
                if let bodyTable = tableContents.firstNodeMatchingSelector("tbody") {
                    for row in bodyTable.children {
                        if let rowElement = row as? HTMLElement { // TODO: should be able to combine this with loop above
                            if let newSchedule = self.parseHTMLRow(rowElement) {
                                self.schedule?.append(newSchedule)
                            }
                        }
                    }
                }
                
                completionHandler(nil)
        }
    }
}
