//
//  Lab10Tests.swift
//  Lab10Tests
//
//  Created by Anton Sipaylo on 6/7/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import XCTest
@testable import Lab10

class Lab10Tests: XCTestCase {
    
    var viewController: ViewController?

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: ViewController.self))
        viewController = storyboard.instantiateInitialViewController() as? ViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }

    override func tearDown() {
    }

    func test0() {
        if let usersInfo = Defaults.getUsersInfo() {
            XCTAssert(usersInfo["ant"] != nil)
            XCTAssert(usersInfo["ant"] == "123")
        }
    }
    
    func test1() {
        viewController?.changeUserMode()
        if let usersInfo = Defaults.getUsersInfo() {
            XCTAssert(usersInfo["anton"] == nil)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
