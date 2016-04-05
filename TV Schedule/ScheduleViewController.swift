//
//  ScheduleViewController.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/20/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var channel: Chanel?

    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    @IBOutlet var dateSC: UISegmentedControl!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var favoriteList: [Chanel]?
    
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
        self.title = channel?.name
        
        self.requestScheduleForDate(NSDate())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let decoded = userDefaults.objectForKey("favorites") as? NSData {
            favoriteList = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? [Chanel]
            if favoriteList!.contains( { $0.channelId == channel?.channelId}) {
                self.favoriteBarButton.image = UIImage(named: "tv")
            } else {
                self.favoriteBarButton.image = UIImage(named: "favorite")
            }
        }
    }

    @IBAction func favoriteToggle(sender: UIBarButtonItem) {
        if favoriteList == nil {
            favoriteList = []
        }
        if favoriteList!.contains( { $0.name == channel?.name}) {
            print("remove item from favorite list")
            favoriteList?.removeAtIndex(favoriteList!.indexOf( {$0.name == channel?.name} )!)
            self.favoriteBarButton.image = UIImage(named: "favorite")
        } else {
            print("add channel to favorite")
            favoriteList?.append(channel!)
            self.favoriteBarButton.image = UIImage(named: "tv")
        }
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(favoriteList!)
        userDefaults.setObject(encodedData, forKey: "favorites")
        userDefaults.synchronize()
    }
    
    @IBAction func dateChanged(sender: UISegmentedControl) {
        self.loadingIndicator.hidden = false
        channel?.schedule = []
        self.scheduleTableView.reloadData()
        
        let selectedDate = NSDate(timeIntervalSinceNow: Double(sender.selectedSegmentIndex)*24*60*60)
        self.requestScheduleForDate(selectedDate)
        
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
        return 60
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
