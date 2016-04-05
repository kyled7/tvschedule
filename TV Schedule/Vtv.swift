//
//  Vtv.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/30/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import Foundation
import Alamofire
import HTMLReader
import Haneke

class Vtv: ChannelSource {
    let UrlString = "http://vtv.vn/lich-phat-song"
    
    override func fetchSchedule(channelId: String, date: NSDate, completion: (result: [Show]) -> Void) {
        var schedule: [Show] = []
        
        let cache = Shared.stringCache
        let URL = NSURL(string: requestUrlForDate(date))
        cache.fetch(URL: URL!).onSuccess { responseString in
            
            let doc = HTMLDocument(string: responseString)
            let wrapper = doc.firstNodeMatchingSelector("#wrapper")
            let channel = wrapper?.nodesMatchingSelector("ul.programs")[Int(channelId)!] as! HTMLElement
            
            for row in channel.children {
                if let rowElement = row as? HTMLElement { // TODO: should be able to combine this with loop above
                    if let newSchedule = self.parseHTMLRow(rowElement) {
                        schedule.append(newSchedule)
                    }
                }
            }
            
            completion(result: schedule)
        }
    }
    
    private func parseHTMLRow(rowElement: HTMLElement) -> Show? {
        var name: String?
        var time: String?
        var additional: String?
        
        //first column: show time
        if let firstColumn = rowElement.firstNodeMatchingSelector(".time") {
            time = firstColumn.textContent
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                .stringByReplacingOccurrencesOfString("\n", withString: "")
        }
        
        //second column: show name
        if let secondColumn = rowElement.firstNodeMatchingSelector(".title") {
            name = secondColumn.textContent
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                .stringByReplacingOccurrencesOfString("\n", withString: "")
        }
        
        //Third column: show additional info
        if let thirdColumn = rowElement.firstNodeMatchingSelector(".genre") {
            additional = thirdColumn.textContent
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                .stringByReplacingOccurrencesOfString("\n", withString: "")
        }
        
        if let name = name, time = time {
            return Show(name: name, time: time, additional: additional)
        }
        
        return nil
    }
    
    private func requestUrlForDate(date: NSDate) -> String {
        let dayFormat = NSDateFormatter()
        dayFormat.dateFormat = "d"
        let dayString = dayFormat.stringFromDate(date)
        
        let monthFormat = NSDateFormatter()
        monthFormat.dateFormat = "M"
        let monthString = monthFormat.stringFromDate(date)
        
        let yearFormat = NSDateFormatter()
        yearFormat.dateFormat = "yyyy"
        let yearString = yearFormat.stringFromDate(date)
        
        return UrlString + "-ngay-" + dayString + "-thang-" + monthString + "-nam-" + yearString + ".htm"
    }
}