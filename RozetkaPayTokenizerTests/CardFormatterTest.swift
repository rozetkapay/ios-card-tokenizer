//
//  CardFormatterTest.swift
//  RozetkaPayTokenizerTests
//
//  Copyright (c) ROZETKAPAY. All rights reserved.
//

import XCTest
@testable import RozetkaPayTokenizer

class CardFormatterTest: XCTestCase {
    var sut: RozetkaPayCardFormatter!
    
    override func setUp() {
        super.setUp()
        sut = RozetkaPayCardFormatter()
    }
    
    func testFormatCardNumberForCardType() {
        let number = "4111_1111_1111_1111"
        let formattedNumber = "4111 1111 1111 1111"
        let formattedAmex = "4111 111111 111111"
        XCTAssertEqual(sut.format(cardNumber: number, for: .visa), formattedNumber)
        XCTAssertEqual(sut.format(cardNumber: number, for: .mastercard), formattedNumber)
        XCTAssertEqual(sut.format(cardNumber: number, for: .amex), formattedAmex)
    }
}

