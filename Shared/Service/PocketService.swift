import Alamofire
import Combine
import Foundation
import SwiftyJSON
import ExtensionKit

// MARK: PocketService Implementation

struct PocketService {
    
    let baseURL = URL(string: "https://getpocket.com/v3")!
    let consumerKey: String
    let session: Session
    
    let camelCaseParameterEncoder: JSONParameterEncoder = {
        let encoder = JSONEncoder()
        // 항상 스네이크 케이스를 사용하는 consumer_key, access_token는 AuthenticationInterceptor가 직접 주입을 담당하므로 괜찮다.
        encoder.keyEncodingStrategy = .useDefaultKeys
        let parameterEncoder = JSONParameterEncoder(encoder: encoder)
        return parameterEncoder
    }()
    
    let snakeCaseParameterEncoder: JSONParameterEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let parameterEncoder = JSONParameterEncoder(encoder: encoder)
        return parameterEncoder
    }()
    
    let decoder: JSONDecoder = {
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
