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
    
    let parameterEncoder: JSONParameterEncoder = {
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
