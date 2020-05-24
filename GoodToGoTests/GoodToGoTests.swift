//
//  GoodToGoTests.swift
//  GoodToGoTests
//
//  Created by Ricardo Santos on 23/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import XCTest
import Nimble

@testable import Core
@testable import GoodToGo

class GoodToGoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {

        CarTrackResolver.shared.api?.getUserDetailV1(completionHandler: { (result) in
            switch result {
            case .success(_):
                _ = 1
            case .failure(_):
                _ = 2
            }
        })


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
