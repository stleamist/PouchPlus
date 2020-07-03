import Foundation
import Combine
import Alamofire

extension PocketService {
    
    func additionPublisher(accessToken: String, query: AdditionQuery) -> AnyPublisher<Result<AdditionContent, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/add"),
            method: .post,
            parameters: query,
            encoder: parameterEncoder,
            interceptor: AuthenticationInterceptor(consumerKey: consumerKey, accessToken: accessToken)
        )
        .publishDecodable(type: AdditionContent.self, decoder: decoder)
        .result()
        .eraseToAnyPublisher()
    }
    
    struct AdditionQuery: Encodable {
        
        let url: URL
        
        var title: String? = nil
        var tags: String? = nil
        var tweetId: String? = nil
        
        // Private
        var time: TimeInterval? = nil
    }

    struct AdditionContent: Decodable {
        let item: AdditionItem
        let status: Int
    }

    struct AdditionItem: Decodable {
        let itemId: String
        let normalUrl: String
        let resolvedId: String
        let extendedItemId: String
        let resolvedUrl: String
        let domainId: String
        let originDomainId: String
        let responseCode: String
        let mimeType: String
        let contentLength: String
        let encoding: String
        let dateResolved: String
        let datePublished: String
        let title: String
        let excerpt: String
        let wordCount: String
        let innerdomainRedirect: String
        let loginRequired: String
        let hasImage: String
        let hasVideo: String
        let isIndex: String
        let isArticle: String
        let usedFallback: String
        let lang: String?
        let timeFirstParsed: String?
//    //    let authors: [String: Item.Author]?
//    //    let images: [String: Item.Image]?
//    //    let videos: [String: Item.Video]?
        let resolvedNormalUrl: String?
        let givenUrl: String
    }
}
