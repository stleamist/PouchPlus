import Alamofire
import Combine
import Foundation
import ExtensionKit

struct PocketService {
    
    let baseURL = URL(string: "https://getpocket.com/v3")!
    
    let consumerKey: String
    
    private init(consumerKey: String) {
        self.consumerKey = consumerKey
    }
    
    static let shared = Self.init(consumerKey: Constant.consumerKey)
    
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

    struct RequestTokenContent: Decodable {
        let code: String
        let state: String?
    }
    
    func requestTokenPublisher(redirectURI: String) -> AnyPublisher<Result<RequestTokenContent, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/oauth/request"),
            method: .post,
            parameters: RequestTokenQuery(
                consumerKey: consumerKey,
                redirectUri: redirectURI
            ),
            encoder: parameterEncoder
        )
        .publishDecodable(type: RequestTokenContent.self, decoder: decoder)
        .result()
        .eraseToAnyPublisher()
    }
    
    // MARK: Access Token
    
    struct AccessTokenQuery: Encodable {
        let consumerKey: String
        let code: String
    }

    struct AccessTokenContent: Decodable {
        let accessToken: String
        let username: String
    }
    
    func accessTokenPublisher(requestToken: String) -> AnyPublisher<Result<AccessTokenContent, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/oauth/authorize"),
            method: .post,
            parameters: AccessTokenQuery(
                consumerKey: consumerKey,
                code: requestToken
            ),
            encoder: parameterEncoder
        )
        .publishDecodable(type: AccessTokenContent.self, decoder: decoder)
        .result()
        .eraseToAnyPublisher()
    }
}
