//
//  CardExpirationDateTest.swift
//  RozetkaPayTokenizerTests
//
//  Copyright (c) ROZETKAPAY. All rights reserved.
//

import XCTest
@testable import RozetkaPayTokenizer

class CardExpirationDateTest: XCTestCase {
    func testInitFromRawDateString() {
        let rawDateString = "04/24"
        var date = try? CardExpirationDate(rawDateString: rawDateString)
        XCTAssertEqual(date?.month, 4)
        XCTAssertEqual(date?.year, 24)
        let rawDateString2 = "1821"
        date = try? CardExpirationDate(rawDateString: rawDateString2)
        XCTAssertEqual(date?.month, 18)
        XCTAssertEqual(date?.year, 21)
        let rawDateStringLong = "04/2024"
        date = try? CardExpirationDate(rawDateString: rawDateStringLong)
        XCTAssertEqual(date?.month, 4)
        XCTAssertEqual(date?.year, 24)
        let rawDateStringTooLong = "4/202424"
        date = try? CardExpirationDate(rawDateString: rawDateStringTooLong)
        XCTAssertNil(date)
        let rawDateStringInvalid = "04"
        date = try? CardExpirationDate(rawDateString: rawDateStringInvalid)
        XCTAssertNil(date)
    }
}
