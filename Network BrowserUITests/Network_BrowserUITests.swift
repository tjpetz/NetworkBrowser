//
//  Network_BrowserUITests.swift
//  Network BrowserUITests
//
//  Created by Thomas Petz, Jr. on 12/24/15.
//  Copyright © 2015 Thomas J. Petz, Jr. All rights reserved.
//

import XCTest

class Network_BrowserUITests: XCTestCase {
        
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
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["local."].tap()
        tablesQuery.staticTexts["_touch-able._tcp.local."].tap()
/*
        tablesQuery.staticTexts["B9BD6730A6B822D9"].tap()
        
        let instancesButton = app.navigationBars["Network_Browser.ServiceDetailView"].buttons["Instances"]
        instancesButton.tap()
        
        let servicesButton = app.navigationBars["Instances"].buttons["Services"]
        servicesButton.tap()
        tablesQuery.staticTexts["_home-sharing._tcp.local."].tap()
        tablesQuery.staticTexts["Thomas Petz, Jr.’s Library"].tap()
        app.otherElements.containing(.navigationBar, identifier:"Network_Browser.ServiceDetailView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.swipeUp()
        instancesButton.tap()
        servicesButton.tap()
        tablesQuery.staticTexts["_workstation._tcp.local."].tap()
        tablesQuery.staticTexts["NAS01 [00:1f:33:ea:86:53]"].tap()
        instancesButton.tap()
        servicesButton.tap()
        app.navigationBars["Services"].buttons["Domains"].tap()
*/
    }
    
}
