import Foundation
import Alamofire
import SwiftyJSON

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
