//
//  ViewController.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 2/22/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//


import UIKit

class ViewController: UICollectionViewController {

    var objects = [StarWarNews]()
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    func session() -> NSURLSession {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.URLCache = NSURLCache .sharedURLCache()
        configuration.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        return NSURLSession(configuration: configuration)
    }
    
    func jsonParser() {
        let urlPath = "https://raw.githubusercontent.com/phunware/services-interview-resources/master/feed.json"
        guard let endpoint = NSURL(string: urlPath) else { print("Error creating endpoint");return }
        let request = NSMutableURLRequest(URL: endpoint, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                guard let dat = data else { throw JSONError.NoData }
                
                
                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options:NSJSONReadingOptions.MutableContainers) as? NSArray else { throw JSONError.ConversionFailed }
                
                for item in json {
                    self.objects.append(StarWarNews(object: item as! NSDictionary))
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView?.reloadData()
                })
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch {
                print(error)
            }
            }.resume()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Phun Homework"
        self.jsonParser()
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
    
    func loadImage(imageURL:NSURL?, completion: ((image: UIImage) -> Void)?)
    {
        guard let url = imageURL else { print("Error creating endpoint");return }
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                let image = UIImage(data: data)
                completion!(image: image!)
            }
        }.resume()

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
    
//    func collectionView(collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
//    {
//        var width : Double
//        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
//            width = Double((self.collectionView?.bounds.width)!) / Double(2.0)
//        }
//        else {
//            width = Double((self.collectionView?.bounds.width)!)
//        }
    
//        Dynamic height based on description text.
//        let object = self.objects[indexPath.row]
//        let text = object["description"] as! String
//        let font = UIFont(name: "Helvetica", size: 17.0)
//        let height = 130 + self.heightForView(text, font:font!, width:CGFloat(width)) + 130.0
        
//        let height = 150.0
//        
//        return CGSize(width: width, height: Double(height))
//    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    }
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.collectionView?.indexPathsForSelectedItems()![0] {
                let object = objects[indexPath.row]
                let controller = segue.destinationViewController as! DetailViewController
                controller.detailItem = object
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
}

