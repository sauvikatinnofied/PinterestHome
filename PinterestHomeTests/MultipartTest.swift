//
//  MultipartTest.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 14/03/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import XCTest
@testable import PinterestHome

class MultipartTest: XCTestCase {
    
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
    
    func testMultipartItemFromImage() {
        let image = UIImage(named: "PinterestLogo.png")
        let multipartItem = image?.multipartBodyItemWith(itemType: .imageJPEG, formKey: "profilePic", fileName: "Image.jpg")
        
        XCTAssert(multipartItem?.mimeType.rawValue == "image/jpeg", "Problem in MIME type selection")
        XCTAssert(multipartItem?.headers.count == 1, "Problem in Header Creation")

    }
    
    func testMultiPartbodyInput() {
        
        let image = UIImage(named: "PinterestLogo.png")
            if let multipartItem = image?.multipartBodyItemWith(itemType: .imageJPEG, formKey: "profilePic", fileName: "Image.jpg") {
            
            XCTAssert(multipartItem.mimeType.rawValue == "image/jpeg", "Problem in MIME type selection")
            XCTAssert(multipartItem.headers.count == 1, "Problem in Header Creation")
            
            let bodyInput = HTTPMultipartBody(parameters: nil, attachments: [multipartItem])
                
                do {                    
                  let data = try bodyInput.endodeToData()
                } catch {
                    //XCAssert(message: "Error while creating multipart body")
                }
                
            
        } else {
            
        }
        
    }
    
}
