//
//  ViewController.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 2/22/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//


import UIKit
import CoreSpotlight
import MobileCoreServices

class ViewController: UICollectionViewController {

    var objects = [StarWarNews]()
    
    var detailViewController : DetailViewController?
    
    var indexSelected : NSInteger?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Phun Homework"
        
        let urlPath = NSURL(string: "https://raw.githubusercontent.com/phunware/services-interview-resources/master/feed.json")
        urlPath?.jsonParser({ json in
            for item in json {
                self.objects.append(StarWarNews(object: item as! NSDictionary))
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView?.reloadData()
                self.setupSearchableContent()
            })

        })
    }
    
    override func viewDidLayoutSubviews() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.count;
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! PhunCollectionViewCell

        let object = objects[indexPath.row]
        
        cell.dateLabel!.text = object.timeStamp?.phunDateString()
        cell.titleLabel!.text = object.title
        cell.locationLabel!.text = object.location1
        cell.descriptionLabel!.text = object.description
        cell.imageURL = object.imageURL
        
        if let image = object.imageURL!.cachedImage {
            // Cached: set immediately.
            cell.imageView!.image = image
            cell.imageView!.alpha = 1
        } else {
            // Not cached, so load then fade it in.
            cell.imageView!.alpha = 0
            object.imageURL!.fetchImage { image in
                // Check the cell hasn't recycled while loading.
                if cell.imageURL == object.imageURL {
                    cell.imageView?.image = image
                    UIView.animateWithDuration(0.3) {
                        cell.imageView!.alpha = 1
                    }
                }
            }
        }
        
        return cell;
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = self.collectionView!.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
                let width = ((self.collectionView?.bounds.width)! - 16) / 3
                flowLayout.itemSize = CGSize(width: width, height: 150)
            } else {
                let width = ((self.collectionView?.bounds.width)! - 12) / 2
                flowLayout.itemSize = CGSize(width: width, height: 150)
            }
        }
        else {
            let width = (self.collectionView?.bounds.width)! - 8
            flowLayout.itemSize = CGSize(width: width, height: 150)
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            self.detailViewController = segue.destinationViewController as? DetailViewController
            if let index = indexSelected {
                let object = objects[index]
                self.detailViewController!.detailItem = object
                indexSelected = nil
            }
            else if let indexPath = self.collectionView?.indexPathsForSelectedItems()![0] {
                let object = objects[indexPath.row]
                self.detailViewController!.detailItem = object
            }
        }
    }

    // change background color when user touches cell
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.grayColor()
    }
    
    // change background color back when user releases touch
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.whiteColor()
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    // func to support deeplink and spotlight
    func processDeeplink(id : NSInteger) {
        if id >= 0 && id < objects.count {
            indexSelected = id
            self.performSegueWithIdentifier("showDetail", sender: nil)
        }
        else {
            let alertView = UIAlertView(title: "Invalid Deeplink ID",
                message: "Article no longer available", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    
    // Setup keywords for spotlight
    func setupSearchableContent() {
        if #available(iOS 9.0, *) {
            
            var searchableItems = [CSSearchableItem]()
            var index = 0
            for object in objects {
                let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                
                let keywords = object.title?.componentsSeparatedByString(" ")
                
                searchableItemAttributeSet.title = object.title
                searchableItemAttributeSet.contentDescription = object.description
                searchableItemAttributeSet.keywords = keywords
                
                
                let image = UIImage(named: "pw.png")
                let imageData = NSData(data: UIImagePNGRepresentation(image!)!)
                searchableItemAttributeSet.thumbnailData = imageData
                
                let id = "com.phunware.Deeplink." + String(index++)
                
                let searchableItem = CSSearchableItem(uniqueIdentifier: id, domainIdentifier: "spotlight.sample", attributeSet: searchableItemAttributeSet)
                
                searchableItems.append(searchableItem)
            }
            
            CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(searchableItems, completionHandler: { (ErrorType) -> Void in
                NSLog("indexed");
            })

            
        } else {
            // Fallback on earlier versions
        }
    }
    
    // provide support for spotlight
    override func restoreUserActivityState(activity: NSUserActivity) {
        if #available(iOS 9.0, *) {
            if activity.activityType == CSSearchableItemActionType {
                if let userInfo = activity.userInfo {
                    let selectedArticle = userInfo[CSSearchableItemActivityIdentifier] as! String
                    NSLog("%@", selectedArticle)
                    indexSelected = Int(selectedArticle.componentsSeparatedByString(".").last!)
                    self.performSegueWithIdentifier("showDetail", sender: nil)

                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
}



