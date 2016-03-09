//
//  NSDate+Additions.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 2/23/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//

import Foundation

extension NSDate {
    func phunDateString () ->String {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let dateTimeString = String(format: "%@ at %@", dateFormatter.stringFromDate(self), timeFormatter.stringFromDate(self))
        
        return dateTimeString

    }
    
    func phunDateStringToDate (dateString : String) ->NSDate {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz'Z'"
        let date = dateFormatter.dateFromString(dateString)
        
        return date!
    }
}