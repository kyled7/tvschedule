//
//  ScheduleViewController.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/20/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var channel: Chanel?

    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    @IBOutlet var dateSC: UISegmentedControl!
    
    var favorites = Favorites.sharedInstance
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy"
        let todayString = dateFormat.stringFromDate(NSDate())
        let tomorowString = dateFormat.stringFromDate(NSDate(timeIntervalSinceNow: 1*24*60*60))
        let twoDaysString = dateFormat.stringFromDate(NSDate(timeIntervalSinceNow: 2*24*60*60))
        
        self.dateSC.setTitle(todayString, forSegmentAtIndex: 0)
        self.dateSC.setTitle(tomorowString, forSegmentAtIndex: 1)
        self.dateSC.setTitle(twoDaysString, forSegmentAtIndex: 2)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.topItem?.title = channel?.name
        
        self.requestScheduleForDate(NSDate())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if favorites.contain(channel!) {
            self.favoriteBarButton.image = UIImage(named: "favorite_selected")
        } else {
            self.favoriteBarButton.image = UIImage(named: "favorite")
        }
    }

    @IBAction func favoriteToggle(sender: UIBarButtonItem) {

        if favorites.contain(channel!) {
            print("remove item from favorite list")
            favorites.removeItem(channel!)
            self.favoriteBarButton.image = UIImage(named: "favorite")
        } else {
            print("add channel to favorite")
            favorites.addItem(channel!)
            self.favoriteBarButton.image = UIImage(named: "favorite_selected")
        }
    }
    
    @IBAction func dateChanged(sender: UISegmentedControl) {
        self.loadingIndicator.hidden = false
        channel?.schedule = []
        self.scheduleTableView.reloadData()
        
        let selectedDate = NSDate(timeIntervalSinceNow: Double(sender.selectedSegmentIndex)*24*60*60)
        self.requestScheduleForDate(selectedDate)
        
    }
    @IBAction func notificationToggle(sender: UIButton) {
        appDelegate.checkAndRequestPermissionForLocalNotification(UIApplication.sharedApplication())
    }
    @IBAction func showAlarmPopover(sender: UIButton) {
        appDelegate.checkAndRequestPermissionForLocalNotification(UIApplication.sharedApplication())
        let alarmPopoverVC = self.storyboard?.instantiateViewControllerWithIdentifier("alarmPopover") as! AlarmPopoverViewController
        alarmPopoverVC.modalPresentationStyle = .Popover
        alarmPopoverVC.preferredContentSize = CGSize(width: 150, height: 50)
        alarmPopoverVC.popoverPresentationController?.permittedArrowDirections = .Up
        alarmPopoverVC.popoverPresentationController?.delegate = self
        alarmPopoverVC.popoverPresentationController?.sourceRect = CGRect(
            x: 0,
            y: 7,
            width: 1,
            height: 1)
        alarmPopoverVC.popoverPresentationController?.sourceView = sender
        
        let btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: scheduleTableView)
        let indexPath: NSIndexPath = scheduleTableView.indexPathForRowAtPoint(btnPos)!
        let show = channel?.schedule![indexPath.row]
        
        let selectedDate = NSDate(timeIntervalSinceNow: Double(dateSC.selectedSegmentIndex)*24*60*60)
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy"
        let showTimeFormat = NSDateFormatter()
        showTimeFormat.dateFormat = "dd-MM-yyyy HH:mm"
        let showTime = showTimeFormat.dateFromString(dateFormat.stringFromDate(selectedDate) + " " + (show?.time)!)
        
        var showName = show?.name ?? ""
        if show?.additional != nil && show?.additional != "" {
            showName.appendContentsOf("\n(\(show!.additional!))")
        }
        
        let notificationItem = NotificationItem(showTime: showTime!, showName: showName, channel: channel!, UUID: NSUUID().UUIDString)
        alarmPopoverVC.notificationItem = notificationItem
        presentViewController(alarmPopoverVC, animated: true, completion: nil)
    }
    
    func requestScheduleForDate(date: NSDate) {
        
        channel?.fetchSchedule(date) { _ in
            self.loadingIndicator.hidden = true
            self.scheduleTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView datasource & delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((self.channel?.schedule) != nil) {
            return (self.channel?.schedule!.count)!
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scheduleTableViewCell", forIndexPath: indexPath) as! ScheduleTableViewCell
        let show = (self.channel?.schedule![indexPath.row])! as Show
        
        cell.timeLabel.text = show.time
        cell.nameLabel.text = show.name
        cell.additionalLabel.text = show.additional
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
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
