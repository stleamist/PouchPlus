import Alamofire
import Combine
import Foundation
import SwiftyJSON
import ExtensionKit

// MARK: PocketService Implementation

struct PocketService {
    
    private let baseURL = URL(string: "https://getpocket.com/v3")!
    private let consumerKey: String
    private let session: Session
    
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
    
    static let shared = Self.init(consumerKey: Constant.consumerKey)
    
    private init(consumerKey: String) {
        self.consumerKey = consumerKey
        
        let configuration = URLSessionConfiguration.af.default
        configuration.headers.add(name: "X-Accept", value: "application/json")
        self.session = Session(configuration: configuration)
    }
}

// MARK: AuthenticationInterceptor

extension PocketService {
    
    struct AuthenticationInterceptor: RequestInterceptor {
        
        var consumerKey: String
        var accessToken: String? = nil
        
        func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
            var urlRequest = urlRequest
            guard let httpBody = urlRequest.httpBody else {
                return
            }
            guard var json = try? JSON(data: httpBody) else {
                assertionFailure("The HTTP body of an URL request is not deserializable.")
                return
            }
            json["consumer_key"].string = consumerKey
            if let accessToken = accessToken {
                json["access_token"].string = accessToken
            }
            guard let modifiedHTTPBody = try? json.rawData() else {
                assertionFailure("The modified HTTP body for an URL request is not serializable.")
                return
            }
            urlRequest.httpBody = modifiedHTTPBody
            completion(.success(urlRequest))
        }
    }
}

// MARK: Request Token

extension PocketService {
    
    struct RequestTokenQuery: Encodable {
        let redirectUri: String
    }

    struct RequestTokenContent: Decodable {
        
        let requestToken: String
        let state: String?
        
        enum CodingKeys: String, CodingKey {
            case requestToken = "code"
            case state
        }
    }
    
    func requestTokenPublisher(query: RequestTokenQuery) -> AnyPublisher<Result<RequestTokenContent, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/oauth/request"),
            method: .post,
            parameters: query,
            encoder: parameterEncoder,
            interceptor: AuthenticationInterceptor(consumerKey: consumerKey)
        )
        .publishDecodable(type: RequestTokenContent.self, decoder: decoder)
        .result()
        .eraseToAnyPublisher()
    }
}
    
// MARK: Access Token

extension PocketService {
    
    struct AccessTokenQuery: Encodable {
        
        let requestToken: String
        
        enum CodingKeys: String, CodingKey {
            case requestToken = "code"
        }
    }

    struct AccessTokenContent: Decodable {
        let accessToken: String
        let username: String
    }
    
    func accessTokenPublisher(query: AccessTokenQuery) -> AnyPublisher<Result<AccessTokenContent, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/oauth/authorize"),
            method: .post,
            parameters: query,
            encoder: parameterEncoder,
            interceptor: AuthenticationInterceptor(consumerKey: consumerKey)
        )
        .publishDecodable(type: AccessTokenContent.self, decoder: decoder)
        .result()
        .eraseToAnyPublisher()
    }
}
