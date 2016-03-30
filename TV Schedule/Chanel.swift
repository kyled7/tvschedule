//
//  Chanel.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/18/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import Foundation
import UIKit

let namespace = "TV_Schedule"

class Chanel : NSObject, NSCoding {
    var channelId: String!
    var schedule: [Show]?
    var name: String?
    var source: String!
    var image: UIImage?
    
    init(channelId: String, source: String) {
        self.channelId = channelId
        self.source = source
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey("channelId") as! String
        let name = aDecoder.decodeObjectForKey("name") as? String
        let source = aDecoder.decodeObjectForKey("source") as! String
        let image = aDecoder.decodeObjectForKey("image") as? UIImage
        self.init(channelId: id, source: source)
        self.name = name
        self.image = image
    }
    
    convenience init(dict: NSDictionary) {
        let id = dict.objectForKey("channelId") as! String
        let source = dict.objectForKey("source") as! String
        self.init(channelId: id, source: source)
        self.name = dict.objectForKey("name") as? String
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
    
    func fetchSchedule(date: NSDate, completionHandler: () -> Void) {
        let channelSourceClass = NSClassFromString(namespace + "." + self.source!) as! NSObject.Type
        let channelSourceObject = channelSourceClass.init() as! ChannelSource
        
        channelSourceObject.fetchSchedule(self.channelId, date: date) { result in
            self.schedule = result
            completionHandler()
        }
        
    }
}

class ChannelSource: NSObject {
    func fetchSchedule(channelId: String, date: NSDate, completion: (result: [Show]) -> Void) {
        completion(result: [])
        print("fetch Schedule by base channel source")
    }
}
