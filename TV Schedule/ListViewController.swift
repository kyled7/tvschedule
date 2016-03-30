//
//  ListViewController.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/19/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var channelSearchBar: UISearchBar!
    
    var listChannel: [Chanel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Danh sách kênh"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.listChannel = []
        if let path = NSBundle.mainBundle().pathForResource("ListChannel", ofType: "plist") {
            let list = NSArray(contentsOfFile: path)
            for item: NSDictionary in list as! [NSDictionary] {
                self.listChannel?.append(Chanel(dict: item))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UICollectionView datasource & delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listChannel!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("listCollectionViewCell", forIndexPath: indexPath) as! ListCollectionViewCell
        
        let channel = listChannel![indexPath.row]
        
        cell.name.text = channel.name
        cell.image.image = channel.image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let scheduleVC = self.storyboard?.instantiateViewControllerWithIdentifier("scheduleVC") as! ScheduleViewController
        scheduleVC.channel = listChannel![indexPath.row]
        self.showViewController(scheduleVC, sender: nil)
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
