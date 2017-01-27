//
//  PinterRestPostTest.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 28/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import XCTest

class PinterRestPostTest: XCTestCase {
    
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
    
    
    // MARK: Model Generation Test
    func testModelLoadFromFile() {
        do  {
            let jsonFilePath = Bundle.main.path(forResource: "PinterestPosts", ofType: "json")
            if let fileURL = URL(string : "file://" + jsonFilePath!) {
                 let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                
                // Trying to serialize
                guard let dicArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
                    return
                }
                let posts = dicArray.map(PinterestPost.init)
                XCTAssertTrue(posts.count == dicArray.count, "JSON Paring Failed from JSON File")
            } else {
                XCTAssert(false, "JSON File Not Found")
            }
           
        } catch {
            debugPrint("Error \(error.localizedDescription)")
            XCTAssert(false, "File Read/ JSON Parsing")
        }
    }
    
}
