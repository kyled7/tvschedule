//
//  AlarmPopoverViewController.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 4/14/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import UIKit

class AlarmPopoverViewController: UIViewController {
    
    var notificationItem: NotificationItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func confirmAlarm(sender: UIButton) {
        NotificationList.sharedInstance.addItem(notificationItem!)
        self.dismissViewControllerAnimated(true, completion: nil)
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
