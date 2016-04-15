//
//  ListViewController.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/19/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var channelSearchBar: UISearchBar!
    
    var listChannel, allChannel: [Chanel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Danh sách kênh"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ListViewController.hideKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.allChannel = []
        if let path = NSBundle.mainBundle().pathForResource("ListChannel", ofType: "plist") {
            let list = NSArray(contentsOfFile: path)
            for item: NSDictionary in list as! [NSDictionary] {
                self.allChannel?.append(Chanel(dict: item))
            }
        }
        listChannel = allChannel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard() {
        if channelSearchBar.isFirstResponder() {
            channelSearchBar.resignFirstResponder()
//            channelSearchBar.showsCancelButton = false
        }
    }
    
    func toggleSearchbar(display: Bool) {
        guard let constraint = channelSearchBar.constraints.filter({ $0.firstAttribute == .Height }).first else {
            return
        }
        print(constraint)
        var constant: CGFloat
        
        if display {
            constant = 44
        } else {
            constant = 0
        }
        
        UIView.animateWithDuration(0.5, animations: {
            constraint.constant = constant
            self.view.setNeedsLayout()
//            self.view.layoutIfNeeded()
        })
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if channelSearchBar.isFirstResponder() {
            return true
        }
        return false
    }
    
    
    // MARK: - UICollectionView datasource & delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listChannel!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("listCollectionViewCell", forIndexPath: indexPath) as! ListCollectionViewCell
        cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
        cell.layer.borderColor = UIColor(white: 1, alpha: 0.5).CGColor
        cell.layer.borderWidth = 1
        
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let maxCellWidth = 160
        let numberCells = Int(UIScreen.mainScreen().bounds.width/CGFloat(maxCellWidth))
        
        let actualCellWidth = CGFloat(Int((UIScreen.mainScreen().bounds.width - CGFloat(numberCells+1)*10) / CGFloat(numberCells)))
        return CGSizeMake(actualCellWidth, actualCellWidth)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollVelocity = scrollView.panGestureRecognizer.velocityInView(scrollView.superview)
        if scrollVelocity.y > 0 {
            toggleSearchbar(true)
        } else {
            toggleSearchbar(false)
        }
    }
    
    // MARK: - UISearchbarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text == "" {
            listChannel = allChannel
        } else {
            listChannel = allChannel?.filter({ $0.name?.lowercaseString.rangeOfString((searchBar.text?.lowercaseString)!) != nil })
        }
        searchBar.resignFirstResponder()
        listCollectionView.reloadData()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        listChannel = allChannel
        listCollectionView.reloadData()
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
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
