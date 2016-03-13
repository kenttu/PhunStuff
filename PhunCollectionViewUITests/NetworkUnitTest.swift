//
//  NetworkUnitTest.swift
//  PhunCollectionView
//
//  Created by Kent Tu on 3/12/16.
//  Copyright © 2016 Kent Tu. All rights reserved.
//

import XCTest
import UIKit

class NetworkUnitTest: XCTestCase {
    
    var numberOfImages : NSInteger?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//            
//        }
//    }
    
    func testArticleFeed() {
        let readyExpectation = expectationWithDescription("ready")
        
        let urlPath = NSURL(string: "https://raw.githubusercontent.com/phunware/services-interview-resources/master/feed.json")
        urlPath?.jsonParser({ json in
            XCTAssert(json.count == 10)
            
            readyExpectation.fulfill()
            
        })

        waitForExpectationsWithTimeout(5, handler: {error in XCTAssertNil(error, "Error")})
    }
    
    func testImagesFeed() {
        let readyExpectation = expectationWithDescription("ready")
        self.numberOfImages = 0

        let urlPath = NSURL(string: "https://raw.githubusercontent.com/phunware/services-interview-resources/master/feed.json")
        urlPath?.jsonParser({ json in
            XCTAssert(json.count == 10)
            
            for object in json {
                let imageURLString = object["image"] as AnyObject as! String
                let imageURL = NSURL(string: imageURLString)
                print("fetching: %@", imageURLString)
                imageURL?.fetchImage({ (image) -> Void in
                    
                    XCTAssertNotNil(image)
                    
                    self.numberOfImages = self.numberOfImages! + 1
                    if (self.numberOfImages == json.count) {
                        readyExpectation.fulfill()
                    }
                })
            
            }
            
            
        })
        
        waitForExpectationsWithTimeout(5, handler: {error in XCTAssertNil(error, "Error")})
    }

}
