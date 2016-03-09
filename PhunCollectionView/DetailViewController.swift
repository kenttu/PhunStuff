//
//  DetailViewController.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 2/23/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    
    var detailItem: StarWarNews? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.titleLabel {
                label.text = detail.title
            }
            if let label = self.dateLabel {
                if let date = detail.timeStamp {
                    label.text =  date.phunDateString()
                }
            }
            if let textView = self.detailTextView {
                textView.text = detail.description
            }
            if let imageView = self.imageView {
                if let imageURL = detail.imageURL {
                    if let image = imageURL.cachedImage {
                        // Cached: set immediately.
                        imageView.image = image
                        imageView.alpha = 1
                    } else {
                        // Not cached, so load then fade it in.
                        imageView.alpha = 0
                        imageURL.fetchImage { image in
                            // Check the cell hasn't recycled while loading.
                            imageView.image = image
                            UIView.animateWithDuration(0.3) {
                                imageView.alpha = 1
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        self.title = "Detail"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonClicked:")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shareButtonClicked(sender: UIButton) {
        
        let textToShare = "Check out " + (self.detailItem?.title)!
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)

    }

}
