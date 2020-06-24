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
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.headers.add(name: "X-Accept", value: "application/json")
        return Session(configuration: configuration)
    }()
    
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
    
    func requestTokenPublisher(redirectURI: String) -> AnyPublisher<DataResponse<String, AFError>, Never> {
        
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
        .map { $0.map(\.code) }
        .eraseToAnyPublisher()
    }
}

struct RequestTokenQuery: Encodable {
    let consumerKey: String
    let redirectUri: String
}

struct RequestTokenResponse: Decodable {
    let code: String
    let state: String?
}
