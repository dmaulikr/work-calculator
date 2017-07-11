//
//  GST_CalculatorUITests.swift
//  GST CalculatorUITests
//
//  Created by Andrew Foster on 7/9/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import XCTest

class GST_CalculatorUITests: XCTestCase {
        
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
        XCUIDevice.shared().orientation = .portrait
        
        let app = XCUIApplication()
        let button = app.buttons["1"]
        button.tap()
        
        let button2 = app.buttons["5"]
        button2.tap()
        app.buttons["+"].tap()
        app.buttons["8"].tap()
        button2.tap()
        
        let button3 = app.buttons["="]
        button3.tap()
        app.buttons["÷"].tap()
        button2.tap()
        button3.tap()
        app.buttons["×"].tap()
        
        let button4 = app.buttons["2"]
        button4.tap()
        button3.tap()
        app.buttons["−"].tap()
        button4.tap()
        app.buttons["0"].tap()
        button3.tap()
        app.buttons["AC"].tap()
        button.tap()
        button4.tap()
        app.buttons["3"].tap()
        
        let button5 = app.buttons["←"]
        button5.tap()
        button5.tap()
        
        app.buttons["+"].tap()
        app.buttons["5"].tap()
        button3.tap()
        
        let menuElementsQuery = app.otherElements.containing(.button, identifier:"menu")
        let element = menuElementsQuery.children(matching: .other).element(boundBy: 0)
        element.children(matching: .other).element(boundBy: 1).textFields["0.00"].tap()
        app.textFields["6"].typeText("50")
        
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        app.buttons["menu"].tap()
        app.buttons["Turn off Ad for $0.99"].tap()
        app.buttons["Restore Purchses"].tap()
        button5.tap()
    }
    
}
