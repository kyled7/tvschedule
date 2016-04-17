//
//  NotificationsViewController.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 4/15/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notificationTV: UITableView!
    
    var notificationsList = NotificationList.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController!.navigationBar.topItem?.title = "Danh sách thông báo"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        notificationTV.reloadData()
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
    
    // MARK: - UITableView datasource & delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationTVCell") as! NotificationTableViewCell
        
        let notificationItem = notificationsList.objectAtIndex(indexPath.row)
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy HH:mm"
        
        cell.channelImage.image = notificationItem.channel.image
        cell.showName.text = notificationItem.showName
        cell.showTime.text = dateFormater.stringFromDate(notificationItem.showTime)
        
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Huỷ"
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let notificationItem = notificationsList.objectAtIndex(indexPath.row)
            notificationsList.removeItem(notificationItem)
            self.notificationTV.reloadData()
        }
        
    }

}

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var showTime: UILabel!
    
}
