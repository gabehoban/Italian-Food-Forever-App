//
//  Italian_Food_ForeverUITests.swift
//  Italian Food ForeverUITests
//
//  Created by Gabriel Hoban on 3/16/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import XCTest

class Italian_Food_ForeverUITests: XCTestCase {

	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.

		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		let app = XCUIApplication()
		setupSnapshot(app)
		app.launch()

		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testExample() {
		// UI tests must launch the application that they test.
		let app = XCUIApplication()
		app.launch()

		let tabBarsQuery = app.tabBars
		tabBarsQuery.buttons["Home"].tap()
		sleep(15)
		snapshot("01Home")
		tabBarsQuery.buttons["Search"].tap()
		snapshot("02Search")
		tabBarsQuery.buttons["My Recipes"].tap()
		let label = app.buttons["Continue with Phone"]
		if label.exists {
			sleep(15)
			snapshot("03Profile")
		} else {
			XCUIApplication().scrollViews.otherElements.buttons["Logout"].tap()
			sleep(15)
			snapshot("03Profile")
		}

	}

	func testLaunchPerformance() {
		if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
			// This measures how long it takes to launch your application.
			measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
				XCUIApplication().launch()
			}
		}
	}
}
