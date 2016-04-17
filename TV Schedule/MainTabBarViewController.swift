//
//  MainTabBarViewController.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 4/7/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateBadge()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainTabBarViewController.updateBadge), name: "updateBadge", object: nil)
    }
    
    func updateBadge() {
        let favoriteCount = Favorites.sharedInstance.count
        if favoriteCount == 0 {
            tabBar.items?[1].badgeValue = nil
        } else {
            tabBar.items?[1].badgeValue = "\(favoriteCount)"
        }
        
        let notificationCount = NotificationList.sharedInstance.count
        if notificationCount == 0 {
            tabBar.items?[2].badgeValue = nil
        } else {
            tabBar.items?[2].badgeValue = "\(notificationCount)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
