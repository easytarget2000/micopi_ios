//
//  micopiTests.swift
//  micopiTests
//
//  Created by Michel Sievers on 25.05.19.
//  Copyright © 2019 Things I Like GmbH. All rights reserved.
//

import XCTest
import Contacts.CNContact
@testable import micopi

class micopiTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testThat_ContactCNConverterCombinesNames() {
        testThat_ContactCNConverterCombinesName(
            givenName: "Anna",
            nickname: "Banana",
            familyName: "Bonano",
            expectedFullName: "Anna \"Banana\" Bonano."
        )
    }
    
    fileprivate func testThat_ContactCNConverterCombinesName(
        givenName: String?,
        nickname: String?,
        familyName: String?,
        expectedFullName: String
    ) {
        let fullName = ContactCNConverter.combineName(
            givenName: givenName,
            nickname: nickname,
            familyName: familyName
        )
        
        XCTAssert(fullName == expectedFullName)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
