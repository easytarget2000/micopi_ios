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
    
//    func testThat_ContactCNConverterCombinesNames() {
//        testThat_ContactCNConverterCombinesName(
//            givenName: "Anna",
//            nickname: "Banana",
//            familyName: "Bonano",
//            expectedFullName: "Anna \"Banana\" Bonano"
//        )
//        testThat_ContactCNConverterCombinesName(
//            givenName: "Jules",
//            expectedFullName: "Jules"
//        )
//        testThat_ContactCNConverterCombinesName(
//            givenName: nil,
//            familyName: "TestFamily",
//            expectedFullName: "TestFamily"
//        )
//        testThat_ContactCNConverterCombinesName(
//            givenName: "Anna",
//            familyName: "Bonano",
//            expectedFullName: "Anna Bonano"
//        )
//    }
//
//    fileprivate func testThat_ContactCNConverterCombinesName(
//        givenName: String?,
//        nickname: String? = nil,
//        familyName: String? = nil,
//        expectedFullName: String
//    ) {
//        let fullName = ContactCNConverter.combineName(
//            givenName: givenName,
//            nickname: nickname,
//            familyName: familyName
//        )
//
//        XCTAssert(fullName == expectedFullName)
//    }
    
    func testThat_ColorPaletteRandomIndexAccessReturnsColor() {
        let colorIndex1 = 40
        let colorIndex2 = -2
        let colorIndex3 = 1
        let colorIndex4 = 2
        let colorIndex5 = 0
        
        let colors = [
            ARGBColor(a: 1.0, r: 1.0, g: 0.5, b: 0.5),
            ARGBColor(a: 0.9, r: 1.0, g: 0.0, b: 0.0)
        ]
        let colorPalette = ARGBColorPalette(colors: colors)
        let _ = colorPalette.color(randomNumber: colorIndex1)
        let _ = colorPalette.color(randomNumber: colorIndex2)
        let color3 = colorPalette.color(randomNumber: colorIndex3)
        let color4 = colorPalette.color(randomNumber: colorIndex4)
        let _ = colorPalette.color(randomNumber: colorIndex5)
        
        XCTAssert(color3 == colorPalette.colors[1])
        XCTAssert(color4 == colorPalette.colors[0])
    }
    
    func testThat_ARGBColorInitsFromHexCorrectly() {
        let hexGreen = ARGBColor(hex: 0xFF00FF00)
        XCTAssert(hexGreen == ARGBColor.green)
        XCTAssert(hexGreen.a == 1.0)
        
        let hexRed = ARGBColor(hex: 0xFFFF0000)
        XCTAssert(hexRed == ARGBColor.red)
        XCTAssert(hexRed.a == 1.0)
    }
    
    func testThat_RandomNumberGeneratorReturnsSameValues() {
        let hash1 = 1000
        let randomNumberGenerator = RandomNumberGenerator()
        randomNumberGenerator.startPoint = hash1
        
        let round1Int1 = randomNumberGenerator.int
        let round1Int2 = randomNumberGenerator.int
        let round1ExpectedInt1 = 8975601842448793600
        let round1ExpectedInt2 = 3139324314117734400
        
        XCTAssert(round1Int1 == round1ExpectedInt1)
        XCTAssert(round1Int2 == round1ExpectedInt2)
        XCTAssert(round1Int1 != round1Int2)
        
        let hash2 = 2000
        randomNumberGenerator.startPoint = hash2
        
        let round2Int1 = randomNumberGenerator.int
        let round2Int2 = randomNumberGenerator.int
        let round2ExpectedInt1 = 7152221116709240832
        let round2ExpectedInt2 = 8585395707903213568
        
        XCTAssert(round2Int1 == round2ExpectedInt1)
        XCTAssert(round2Int2 == round2ExpectedInt2)
        XCTAssert(round2ExpectedInt1 != round2ExpectedInt2)
        
        XCTAssert(round1Int1 != round2Int1)
    }
    
    func testThat_ContactHashWrapperViewModelModifiesHash() {
        let contact = Contact(
            identifier: "",
            givenName: "",
            familyName: "",
            nickname: "",
            mainEmailAddress: nil,
            mainPhoneNumber: nil
        )
        let contactWrapper = ContactHashWrapper(contact: contact)
        let hash1 = contactWrapper.hashValue
        
        let viewModel = ContactHashWrapperViewModel()
        viewModel.contactWrapper = contactWrapper
        
        viewModel.generateNextImage()
        let hash2 = contactWrapper.hashValue
        viewModel.generatePreviousImage()
        let hash3 = contactWrapper.hashValue
        
        XCTAssert(hash1 == hash3)
        XCTAssert(hash1 != hash2)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
