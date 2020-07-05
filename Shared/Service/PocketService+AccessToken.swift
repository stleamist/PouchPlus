import Combine
import Alamofire

extension PocketService {
    
    func accessTokenPublisher(query: AccessTokenQuery) -> AnyPublisher<Result<AccessTokenContent, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/oauth/authorize"),
            method: .post,
            parameters: query,
            encoder: snakeCaseParameterEncoder,
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

// KeychainStorage 저장을 위한 Encodable 프로토콜 준수
// 참고: Codable 프로토콜은 선언된 파일 외부에서 준수할 수 없기에 여기에 작성했다.
extension PocketService.AccessTokenContent: Encodable {}
