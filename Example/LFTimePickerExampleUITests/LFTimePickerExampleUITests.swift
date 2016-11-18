//
//  LFTimePickerExampleUITests.swift
//  LFTimePickerExampleUITests
//
//  Created by Lucas Farah on 6/3/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//
// swiftlint:disable line_length
// swiftlint:disable trailing_whitespace

import XCTest

class LFTimePickerExampleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testSelectingTime() {
       
        
        let app = XCUIApplication()
        app.buttons["Choose time"].tap()

        let tables = XCUIApplication().tables.allElementsBoundByIndex
        let leftTable = tables[0]
        let rightTable = tables[1]

        leftTable.staticTexts["0:10"].swipeUp()
        rightTable.staticTexts["0:10"].swipeUp()

        app.navigationBars["Change Time"].buttons["Save"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
