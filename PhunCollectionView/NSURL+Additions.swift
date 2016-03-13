//
//  NSURL+Additions.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 3/4/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//

import UIKit

extension NSURL {
    
    typealias ImageCacheCompletion = UIImage -> Void
    
    /// Retrieves a pre-cached image, or nil if it isn't cached.
    /// You should call this before calling fetchImage.
    var cachedImage: UIImage? {
        return ImageCache.sharedCache.objectForKey(
            absoluteString) as? UIImage
    }
    
    /// Fetches the image from the network.
    /// Stores it in the cache if successful.
    /// Only calls completion on successful image download.
    /// Completion is called on the main thread.
    func fetchImage(completion: ImageCacheCompletion) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(self) {
            data, response, error in
            if error == nil {
                if let  data = data,
                    image = UIImage(data: data) {
                        ImageCache.sharedCache.setObject(
                            image,
                            forKey: self.absoluteString,
                            cost: data.length)
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(image)
                        }
                }
            }
        }
        task.resume()
    }
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    func jsonParser(completion: NSArray -> Void) {
        
        let request = NSMutableURLRequest(URL: self, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60)
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            do {
                guard let dat = data else { throw JSONError.NoData }
                
                guard let json = try NSJSONSerialization.JSONObjectWithData(dat, options:NSJSONReadingOptions.MutableContainers) as? NSArray else { throw JSONError.ConversionFailed }
                
                dispatch_async(dispatch_get_main_queue()) {
                    completion(json)
                }
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch {
                print(error)
            }
            }.resume()
    }

    
}