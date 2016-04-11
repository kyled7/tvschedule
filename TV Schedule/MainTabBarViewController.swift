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
        if let decoded = userDefaults.objectForKey("favorites") as? NSData {
            let favoriteList = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? [Chanel]
            if favoriteList?.count == 0 {
                tabBar.items?[1].badgeValue = nil
            } else {
                tabBar.items?[1].badgeValue = "\(favoriteList!.count)"
            }
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
