//
//  CachingTest.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 28/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import XCTest

class CachingTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSingleImageCaching() {
        
        let imageURL = "https://images.unsplash.com/photo-1464550883968-cec281c19761"
        let iconData = UIImageJPEGRepresentation(UIImage(named: "PinterestLogo")!, 1.0)!
        var cache = OnMemoryCache(maxSizeInKB: 1024)
        cache[imageURL] = CacheItem(data: iconData, key: imageURL)
        
        XCTAssertNotNil(cache[imageURL],"Caching Failed")
        XCTAssertTrue(iconData.count / 1024 == cache.currentSize, "Data Saving Error while caching")
    }
    
    func testPurgeForImageCaching() {
        let imageArray = Array(0..<200).map { _ in return UIImage(named: "PinterestLogo")!}
        let imageURL = "https://images.unsplash.com/photo-1464550883968-cec281c19761"
        var cache = OnMemoryCache(maxSizeInKB: 50)
        
        // Adding images of 5 * 20 KB
        for (index,image) in imageArray.enumerated() {
           let key = imageURL + "_\(index)"
           let iconData = UIImageJPEGRepresentation(image, 1.0)!
           cache[key] = CacheItem(data: iconData, key: key)
        }
        
        // Checking current size of cache
        XCTAssertTrue(cache.currentSize <= 50, "Data Saving Error while caching")
    }
}
