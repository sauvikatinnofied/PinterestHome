//
//  PinterestHomeUITests.swift
//  PinterestHomeUITests
//
//  Created by Sauvik Dolui on 28/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import XCTest

class PinterestHomeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomeScreenLoading() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        let image = collectionViewsQuery.children(matching: .cell).element(boundBy: 2).otherElements.children(matching: .image).element
        image.swipeDown()
        
        let image2 = collectionViewsQuery.children(matching: .cell).element(boundBy: 8).otherElements.children(matching: .image).element
        image2.swipeUp()
        
        let collectionView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element
        collectionView.swipeDown()
        image2.swipeUp()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).otherElements.children(matching: .image).element.swipeDown()
        image2.swipeUp()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 4).otherElements.children(matching: .image).element.swipeDown()
        
        let image3 = collectionViewsQuery.children(matching: .cell).element(boundBy: 6).otherElements.children(matching: .image).element
        image3.swipeUp()
        image3.tap()
        collectionView.swipeUp()
        
        let image4 = collectionViewsQuery.children(matching: .cell).element(boundBy: 7).otherElements.children(matching: .image).element
        image4.swipeUp()
        image3.swipeUp()
        collectionView.swipeDown()
        image.swipeDown()
        image3.swipeUp()
        image4.swipeUp()
        image2.swipeDown()
        
        
        
    }
    
}
