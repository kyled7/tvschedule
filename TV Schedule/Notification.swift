//
//  Notification.swift
//  TV Schedule
//
//  Created by Dinh Ngoc Kien on 4/8/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import Foundation
import UIKit

class NotificationItem: NSObject, NSCoding {
    var showTime : NSDate
    var showName: String
    var channel: Chanel
    var UUID: String
    
    init(showTime: NSDate, showName: String, channel: Chanel, UUID: String) {
        self.showTime = showTime
        self.showName = showName
        self.channel = channel
        self.UUID = UUID
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let showTime = aDecoder.decodeObjectForKey("showTime") as! NSDate
        let showName = aDecoder.decodeObjectForKey("showName") as! String
        let channel = aDecoder.decodeObjectForKey("channel") as! Chanel
        let UUID = aDecoder.decodeObjectForKey("UUID") as! String
        self.init(showTime: showTime, showName: showName, channel: channel, UUID: UUID)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(showTime, forKey: "showTime")
        aCoder.encodeObject(showName, forKey: "showName")
        aCoder.encodeObject(channel, forKey: "channel")
        aCoder.encodeObject(UUID, forKey: "UUID")
        
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.showTime) == NSComparisonResult.OrderedDescending)
    }
    
}

class NotificationList {
    class var sharedInstance : NotificationList {
        struct Static {
            static let instance : NotificationList = NotificationList()
        }
        return Static.instance
    }
    
    private let ITEMS_KEY = "notificationShows"
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var list : [String: NotificationItem]
    var count: Int {
        return list.count
    }
    
    init() {
        if let decoded = userDefaults.objectForKey(ITEMS_KEY) as? NSData {
            list = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as! [String: NotificationItem]
        } else {
            list = [:]
        }
        
    }
    
    func addItem(item: NotificationItem) {
        list[item.UUID] = item
        save()
        
        let notification = UILocalNotification()
        notification.alertBody = "ĐỪNG BỎ LỠ!!! \nĐón xem chương trình \(item.showName) sắp được chiếu trên kênh \(item.channel.name!)"
        notification.alertAction = "open"
        notification.fireDate = item.showTime.dateByAddingTimeInterval(-60*5)
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["UUID": item.UUID, ]
        notification.category = "TVSHOW_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func removeItem(item: NotificationItem) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if (notification.userInfo!["UUID"] as! String == item.UUID) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
        
        list.removeValueForKey(item.UUID)
        save()
    }
    
    func objectAtIndex(index: Int) -> NotificationItem {
        return Array(list.values).sort({$0.showTime.timeIntervalSinceNow < $1.showTime.timeIntervalSinceNow})[index]
    }
    
    private func save() {
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(list)
        userDefaults.setObject(encodedData, forKey: ITEMS_KEY)
        userDefaults.synchronize()
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "updateBadge", object: nil))
    }
}
