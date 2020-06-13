//
//  Test_TestCases.swift
//  Test.TestCases
//
//  Created by Ricardo Santos on 24/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import XCTest

@testable import GoodToGo

@testable import Core
@testable import Core_Bliss

@testable import Domain
@testable import Domain_Bliss

class Test_Bliss: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_resolvers() {
        XCTAssert(GoodToGo.BlissResolver.shared.api != nil)
        XCTAssert(GoodToGo.BlissResolver.shared.genericBusiness != nil)
    }

    func test_api_getHealth() {
        let expectation = self.expectation(description: #function)
        GoodToGo.BlissResolver.shared.api?.getHealth(completionHandler: { (result) in
            switch result {
            case .success: XCTAssert(true)
            case .failure: XCTAssert(false)
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: TestsShared.shared.waitForExpectationsDefaultTime)
    }
}
