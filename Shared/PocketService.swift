import Alamofire
import Combine
import Foundation
import ExtensionKit

struct PocketService {
    
    let baseURL = URL(string: "https://getpocket.com/v3")!
    
    let consumerKey: String
    let accessToken: String?
    
    static let shared = PocketService(consumerKey: Constant.consumerKey)
    
    private init(consumerKey: String, accessToken: String? = nil) {
        self.consumerKey = consumerKey
        self.accessToken = accessToken
    }
    
    // MARK: Session
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.headers.add(name: "X-Accept", value: "application/json")
        return Session(configuration: configuration)
    }()
    
    // MARK: Encoder & Decoder
    
    private let parameterEncoder: JSONParameterEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let parameterEncoder = JSONParameterEncoder(encoder: encoder)
        return parameterEncoder
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: Request Token
    
    struct RequestTokenQuery: Encodable {
        let consumerKey: String
        let redirectUri: String
    }

    struct RequestTokenResponse: Decodable {
        let code: String
        let state: String?
    }
    
    func requestTokenPublisher(redirectURI: String) -> AnyPublisher<Result<String, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/oauth/request"),
            method: .post,
            parameters: RequestTokenQuery(
                consumerKey: consumerKey,
                redirectUri: redirectURI
            ),
            encoder: parameterEncoder
        )
        .publishDecodable(type: RequestTokenResponse.self, decoder: decoder)
        .result()
        .map { $0.map(\.code) }
        .eraseToAnyPublisher()
    }
    
    // MARK: Access Token
    
    struct AccessTokenQuery: Encodable {
        let consumerKey: String
        let code: String
    }

    struct AccessTokenResponse: Decodable {
        let accessToken: String
        let username: String
    }
    
    func accessTokenPublisher(requestToken: String) -> AnyPublisher<Result<String, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/oauth/authorize"),
            method: .post,
            parameters: AccessTokenQuery(
                consumerKey: consumerKey,
                code: requestToken
            ),
            encoder: parameterEncoder
        )
        .publishDecodable(type: AccessTokenResponse.self, decoder: decoder)
        .result()
        .map { $0.map(\.accessToken) }
        .eraseToAnyPublisher()
    }
}