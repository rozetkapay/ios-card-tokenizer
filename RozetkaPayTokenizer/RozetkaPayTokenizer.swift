/*
* Copyright (c) ROZETKAPAY - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
*/

import Foundation

public struct RozetkaPayTokenSuccess: Codable {
    public let token: String
}

public struct RozetkaPayTokenDataSuccess: Codable {
    public let data: String
}

public class RozetkaPayTokenizer {
    // MARK: - Private Properties
    private let apiKey: String
    private let environment: Environment
    private let urlSession = URLSession.shared
    private let decoder = DataDecoder()
    private let encoder = DataEncoder()
    
    // MARK: - Init
    /// - parameter apiKey: Merchant's unique key, used for authorization purposes
    /// - parameter environment: Use `.stage` to test the workflow without affecting real values, use `.prod` for release versions.
    public init(apiKey: String, environment: Environment) {
        self.apiKey = apiKey
        self.environment = environment
    }
    
    // MARK: - Public Methods
    /// Sends encoded `card` to RozetkaPay servers
    ///
    /// - parameter card:          The `CardRequestData` value, make sure `rich` is set to `false`.
    /// - parameter result:        Closure, called when token data or an error is received
    public func tokenize(card: CardRequestData,
                         result: @escaping (Result<RozetkaPayTokenSuccess, RozetkaPayTokenError>) -> Void) {
        fetch(card: card, completionHandler: result)
    }
    
    /// Sends encoded and ecrypted `card` to RozetkaPay servers
    ///
    /// - parameter card:          The `CardRequestData` value, make sure `rich` is set to `true`.
    /// - parameter result:        Closure, called when token data or an error is received
    public func tokenizeEncrypt(card: CardRequestData,
                                result: @escaping (Result<RozetkaPayTokenDataSuccess, RozetkaPayTokenError>) -> Void) {
        var richCard = card
        richCard.rich = true
        fetch(card: richCard, completionHandler: result)
    }
    
    // MARK: - Private Methods
    private func fetch<T>(card: CardRequestData,
                          completionHandler: @escaping (Result<T, RozetkaPayTokenError>) -> Void) where T: Codable {
        let sign = self.encoder.stringEncode(card)?.hmac(key: apiKey)
        
        if var request = URLRequestBuilder.createURLRequest(to: environment.baseURL, requestData: .tokenize(card: card)) {
            request.setValue(sign, forHTTPHeaderField: "X-Sign")
            request.setValue(apiKey, forHTTPHeaderField: "X-Widget-Id")
            request.httpBody = try? encoder.encode(card)
            
            urlSession.dataTask(with: request) { (result) in
                switch result {
                case .success(let (response, data)):
                    guard
                        let statusCode = (response as? HTTPURLResponse)?.statusCode,
                        200..<299 ~= statusCode
                    else {
                        if let error = self.parseApiError(data: data) {
                            completionHandler(.failure(error))
                        }
                        return
                    }
                    do {
                        completionHandler(.success(try self.decoder.decode(T.self, from: data)))
                    } catch {
                        let error = RozetkaPayTokenError(message: error.localizedDescription)
                        completionHandler(.failure(error))
                    }
                case .failure(let error):
                    completionHandler(.failure(RozetkaPayTokenError(message: error.localizedDescription)))
                }
            }.resume()
        }
    }
    
    private func parseApiError(data: Data?) -> RozetkaPayTokenError? {
        if let jsonData = data {
            return try? self.decoder.decode(RozetkaPayTokenError.self, from: jsonData)
        }
        return RozetkaPayTokenError(message: Constants.genericErrorMessage)
    }
    
}
