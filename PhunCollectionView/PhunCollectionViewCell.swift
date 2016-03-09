//
//  PhunCollectionViewCell.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 2/22/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//

import UIKit

class PhunCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel : UILabel?
    @IBOutlet weak var titleLabel : UILabel?
    @IBOutlet weak var locationLabel : UILabel?
    @IBOutlet weak var descriptionLabel : UILabel?
    @IBOutlet weak var imageView : UIImageView?
    var imageURL : NSURL?
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.darkGrayColor()
        
        let textColor = UIColor.whiteColor()
        self.dateLabel?.textColor = textColor
        self.titleLabel?.textColor = textColor
        self.locationLabel?.textColor = textColor
        self.descriptionLabel?.textColor = textColor
        
    }
}
