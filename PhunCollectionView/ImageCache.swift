//
//  ImageCache.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 3/4/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//

import Foundation

class ImageCache {
    
    static let sharedCache: NSCache = {
        let cache = NSCache()
        cache.name = "ImageCache"
        cache.countLimit = 20 // Max 20 images in memory.
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()
    
}