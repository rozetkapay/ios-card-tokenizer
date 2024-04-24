/*
* Copyright (c) ROZETKAPAY - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
*/

import XCTest
@testable import RozetkaPayTokenizer

class RozetkaPayTokenizerTest: XCTestCase {
    var sut: RozetkaPayTokenizer!
    var card: CardRequestData!
    var invalidCard: CardRequestData!

    private let apiToken = "m03z1jKTSO6zUYQN5C8xYZnIclK0plIQ/3YMgTZbV6g7kxle6ZnCaHVNv3A11UCK"

    override func setUp() {
        super.setUp()
        sut = RozetkaPayTokenizer(apiKey: apiToken, environment: .stage)
        card = TestHelpers.createValidCardRequestData()
        invalidCard = TestHelpers.createInvalidCardRequestData()
    }
    
    func testMakeSuccessRequest() {
        let expectation = XCTestExpectation(description: "Get token")
        sut.tokenize(card: card) { (result: Result<RozetkaPayTokenSuccess, RozetkaPayTokenError>) in
            switch result {
            case .success(let cardToken):
                print(cardToken)
                XCTAssertNotNil(cardToken)
                XCTAssertNotNil(cardToken.token)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 4.0)
    }

    func testMakeEncryptSuccessRequest() {
        let expectation = XCTestExpectation(description: "Get encrypted token")
        sut.tokenizeEncrypt(card: card) { (result: Result<RozetkaPayTokenDataSuccess, RozetkaPayTokenError>) in
            switch result {
            case .success(let cardToken):
                print(cardToken)
                XCTAssertNotNil(cardToken)
                XCTAssertNotNil(cardToken.data)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 4.0)
    }
    
    func testMakeFailureRequest() {
        let expectation = XCTestExpectation(description: "Failure token")
        sut.tokenize(card: invalidCard) { (result: Result<RozetkaPayTokenSuccess, RozetkaPayTokenError>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                print("Response error: \(error)")
                XCTAssertNotNil(error.message)
                expectation.fulfill()
            }
        }
        
         wait(for: [expectation], timeout: 4.0)
    }

    override func tearDown() {
        sut = nil
    }

}
