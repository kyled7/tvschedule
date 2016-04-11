//
//  Favorites.swift
//  TV Schedule
//
//  Created by Dinh Ngoc Kien on 4/11/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import Foundation

class Favorites {
    private let ITEMS_KEY = "favorites"
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var listFavorite : [Chanel]
    var count: Int {
        return listFavorite.count
    }
    
    class var sharedInstance : Favorites {
        struct Static {
            static let instance : Favorites = Favorites()
        }
        return Static.instance
    }
    
    init() {
        if let decoded = userDefaults.objectForKey(ITEMS_KEY) as? NSData {
            listFavorite = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as! [Chanel]
        } else {
            listFavorite = []
        }
        
    }
    
    func addItem(channel: Chanel) {
        listFavorite.append(channel)
        save()
    }
    
    func removeItem(channel: Chanel) {
        listFavorite.removeAtIndex(listFavorite.indexOf( {$0.name == channel.name} )!)
        save()
    }
    
    func objectAtIndex(index: Int) -> Chanel {
        return listFavorite[index]
    }
    
    func contain(channel: Chanel) -> Bool {
        if listFavorite.contains( { $0.name == channel.name}) {
            return true
        }
        return false
    }
    
    private func save() {
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(listFavorite)
        userDefaults.setObject(encodedData, forKey: ITEMS_KEY)
        userDefaults.synchronize()
    }
}
