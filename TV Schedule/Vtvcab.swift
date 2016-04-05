//
//  Vtvcab.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/30/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import Foundation
import Alamofire
import HTMLReader
import Haneke

class Vtvcab: ChannelSource {
    let URLString = "http://www.vtvcab.vn/lich-phat-song"
    
    override func fetchSchedule(channelId: String, date: NSDate, completion: (result: [Show]) -> Void) {
        
        var schedule: [Show] = []
        
        let cache = Shared.stringCache
        let URL = NSURL(string: requestUrlForDate(date, channelId: channelId))
        cache.fetch(URL: URL!).onSuccess { responseString in
            let doc = HTMLDocument(string: responseString)
            
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
                completion(result: schedule)
                return
            }
            
            if let bodyTable = tableContents.firstNodeMatchingSelector("tbody") {
                for row in bodyTable.children {
                    if let rowElement = row as? HTMLElement { // TODO: should be able to combine this with loop above
                        if let newSchedule = self.parseHTMLRow(rowElement) {
                            schedule.append(newSchedule)
                        }
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
    
    private func requestUrlForDate(date: NSDate, channelId: String) -> String {
        let dayFormat = NSDateFormatter()
        dayFormat.dateFormat = "dd"
        let dayString = dayFormat.stringFromDate(date)
        
        let monthFormat = NSDateFormatter()
        monthFormat.dateFormat = "MM"
        let monthString = monthFormat.stringFromDate(date)
        
        let yearFormat = NSDateFormatter()
        yearFormat.dateFormat = "yyyy"
        let yearString = yearFormat.stringFromDate(date)
        
        return URLString + "?day=" + dayString + "&month=" + monthString + "&year=" + yearString + "&channel=" + channelId
    }
}