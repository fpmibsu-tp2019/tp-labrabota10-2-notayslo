//
//  Lab10UITests.swift
//  Lab10UITests
//
//  Created by Anton Sipaylo on 6/7/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import XCTest

class Lab10UITests: XCTestCase {
    
    let textFieldsNames = ["SignInEmail", "SignInPassword", "SignUpEmail", "SignUpPassword", "SignUpRepeatedPassword"]
    
    let buttonsNames = ["SignInButtonIn", "SignUpButtonIn", "SignInButtonUp", "SignUpButtonUp"]
    
    let labelsNames = ["HotelName", "HotelDescription", "HotelCity"]

    var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test0() {
        XCTAssert(app.exists)
    }
    
    func test1() {
        XCTAssert(app.textFields[textFieldsNames[0]].exists)
        XCTAssert(app.textFields[textFieldsNames[1]].exists)
    }
    
    func test2() {
        app.buttons[buttonsNames[1]].tap(withNumberOfTaps: 1, numberOfTouches: 1)
        XCTAssert(app.textFields[textFieldsNames[2]].exists)
        XCTAssert(app.textFields[textFieldsNames[3]].exists)
        XCTAssert(app.textFields[textFieldsNames[4]].exists)
    }
    
    func test3() {
        XCTAssert(app.textFields[textFieldsNames[0]].exists)
        XCTAssert(app.textFields[textFieldsNames[1]].exists)
        app.textFields[textFieldsNames[0]].tap(withNumberOfTaps: 1, numberOfTouches: 1)
        app.textFields[textFieldsNames[0]].typeText("ant")
        app.textFields[textFieldsNames[1]].tap(withNumberOfTaps: 1, numberOfTouches: 1)
        app.textFields[textFieldsNames[1]].typeText("123")
        app.buttons[buttonsNames[0]].tap(withNumberOfTaps: 1, numberOfTouches: 1)
        XCTAssert(app.staticTexts[labelsNames[0]].exists)
    }

}
