//
//  StarWarNews.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 2/23/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//

import Foundation

class StarWarNews {
    
    var title : String?
    var timeStamp : NSDate?
    var imageURL : NSURL?
    var location1 : String?
    var location2 : String?
    var description : String?
    
    init(object : NSDictionary) {
        self.title = object["title"] as? String
        if let timeStamp = object["timestamp"] {
            self.timeStamp = NSDate().phunDateStringToDate(timeStamp as! String)
        }
        if let imageURL = object["image"] {
            self.imageURL = NSURL(string: imageURL as! String)!
        }
        self.location1 = object["locationline1"] as? String
        self.location2  = object["locationline2"] as? String
        self.description = object["description"] as? String
        
     }
}