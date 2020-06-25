import Combine
import Alamofire

extension PocketService {
    
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
}
