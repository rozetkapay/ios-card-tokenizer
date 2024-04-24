//
//  URLRequestBuilderTest.swift
//  RozetkaPayTokenizerTests
//
//  Copyright (c) ROZETKAPAY. All rights reserved.
//

import XCTest
@testable import RozetkaPayTokenizer

class URLRequestBuilderTest: XCTestCase {
  func testCreateURLRequest() {
    let data = TestHelpers.createRequestData()
    let request = URLRequestBuilder.createURLRequest(to: "test.com", requestData: data)
    XCTAssertEqual(request?.httpMethod, data.method.rawValue)
    XCTAssertNotNil(request?.allHTTPHeaderFields)
  }
}
