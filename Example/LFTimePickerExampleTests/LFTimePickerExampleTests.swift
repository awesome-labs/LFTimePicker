//
//  LFTimePickerExampleTests.swift
//  LFTimePickerExampleTests
//
//  Created by Lucas Farah on 6/3/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//

// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length



import XCTest
@testable import LFTimePickerExample

class LFTimePickerExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeArray12h() {
        let timePicker = LFTimePickerController()
        let timeStringArray = timePicker.defaultTimeArray12()
        
        let ampm = 2
        let hours = 12
        let minutes = 12
        let spaces = 9 + 9
        XCTAssertEqual(timeStringArray.count, spaces + (ampm * hours * minutes))
    }
    
    func testTimeArray24h() {
        
        let timePicker = LFTimePickerController()
        let timeStringArray = timePicker.defaultTimeArray12()
        
        let hours = 24
        let minutes = 12
        let spaces = 9 + 9
        XCTAssertEqual(timeStringArray.count, spaces + (hours * minutes))
    }    
}
