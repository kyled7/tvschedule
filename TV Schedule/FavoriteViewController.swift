//
//  FavoriteViewController.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/28/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var favoriteTableView: UITableView!
    
    var favorites = Favorites.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Kênh yêu thích"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.favoriteTableView.reloadData()
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
    
    //MARK: - UITableView datasource & delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteTableViewCell", forIndexPath: indexPath) as! FavoriteTableViewCell
        
        let channel = favorites.objectAtIndex(indexPath.row)
        
        cell.name.text = channel.name
        cell.channelImage.image = channel.image
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let scheduleVC = self.storyboard?.instantiateViewControllerWithIdentifier("scheduleVC") as! ScheduleViewController
        scheduleVC.channel = favorites.objectAtIndex(indexPath.row)
        self.showViewController(scheduleVC, sender: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Bỏ yêu thích"
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let channel = favorites.objectAtIndex(indexPath.row)
            favorites.removeItem(channel)
            self.favoriteTableView.reloadData()
        }
        
    }

}
