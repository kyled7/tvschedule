//
//  Notification.swift
//  TV Schedule
//
//  Created by Dinh Ngoc Kien on 4/8/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import Foundation
import UIKit

struct NotificationItem {
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
    
    func addItem(item: NotificationItem) {
        var notificationDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary()
        
        notificationDictionary[item.UUID] = ["showTime": item.showTime, "showName": item.showName, "channel": item.channel, "UUID": item.UUID]
        NSUserDefaults.standardUserDefaults().setObject(notificationDictionary, forKey: ITEMS_KEY)
        
        let notification = UILocalNotification()
        notification.alertBody = "ĐỪNG BỎ LỠ!!! \n Đón xem chương trình \(item.showName) sắp được chiếu trên kênh \(item.channel.name)"
        notification.alertAction = "open"
        notification.fireDate = item.showTime.dateByAddingTimeInterval(-60*10)
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
        
        if var notificationItems = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) {
            notificationItems.removeValueForKey(item.UUID)
            NSUserDefaults.standardUserDefaults().setObject(notificationItems, forKey: ITEMS_KEY)
        }
    }
}
