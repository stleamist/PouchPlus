import Combine
import Alamofire

extension PocketService {
    
    func requestTokenPublisher(query: RequestTokenQuery) -> AnyPublisher<Result<RequestTokenContent, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/oauth/request"),
            method: .post,
            parameters: query,
            encoder: snakeCaseParameterEncoder,
            interceptor: AuthenticationInterceptor(consumerKey: consumerKey)
        )
        .publishDecodable(type: RequestTokenContent.self, decoder: decoder)
        .result()
        .eraseToAnyPublisher()
    }
    
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
}
