//
//  UIImageView+URL.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 2/27/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageURL(imageURL : NSURL) {
        
        let request = NSMutableURLRequest(URL: imageURL, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.image = UIImage(data: data)
            }
        }.resume()
    }
    
    func loadImageWithURL(imageURL:NSURL?, completion: ((image: UIImage) -> Void)?)
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

}
