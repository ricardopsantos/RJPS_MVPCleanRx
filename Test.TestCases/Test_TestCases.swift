//
//  Test_TestCases.swift
//  Test.TestCases
//
//  Created by Ricardo Santos on 24/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import XCTest

//@testable import GoodToGo
//@testable import Core
@testable import Domain

class Test_TestCases: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {

        print(Domain.AppCodes.ignored)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
