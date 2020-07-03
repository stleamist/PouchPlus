import Foundation
import Combine
import Alamofire

extension PocketService {
    
    func retrievalPublisher(accessToken: String, query: RetrievalQuery) -> AnyPublisher<Result<RetrievalContent, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/get"),
            method: .post,
            parameters: query,
            encoder: parameterEncoder,
            interceptor: AuthenticationInterceptor(consumerKey: consumerKey, accessToken: accessToken)
        )
        .publishDecodable(type: RetrievalContent.self, decoder: decoder)
        .result()
        .eraseToAnyPublisher()
    }

    struct RetrievalQuery: Encodable {
        
        var state: State? = nil
        var favorite: Favorite? = nil
        var tag: Tag? = nil
        var contentType: ContentType? = nil
        var sort: Sort? = nil
        var detailType: DetailType? = nil
        var search: String? = nil
        var domain: String? = nil
        var since: TimeInterval? = nil
        var count: Int? = nil
        var offset: Int? = nil
        
        enum State: String, Encodable {
            case unread
            case archive
            case all
        }
        
        enum Favorite: Int, Encodable {
            case unfavorited = 0
            case favorited = 1
        }
        
        enum Tag: Encodable {
            case named(name: String)
            case untagged
            
            private var stringValue: String {
                switch self {
                case .named(let name): return name
                case .untagged: return "_untagged_"
                }
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(stringValue)
            }
        }
        
        enum ContentType: String, Encodable {
            case article
            case video
            case image
        }
        
        enum Sort: String, Encodable {
            case newest
            case oldest
            case title
            case site
        }
        
        enum DetailType: String, Encodable {
            case simple
            case complete
        }
    }

    struct RetrievalContent: Decodable {
        let status: Int
        let complete: Int
        let list: [String: Item]
        let searchMeta: [String: String]
        let since: Int
    }

    struct Item: Codable {
        
        // DetailType: Simple
        let itemId: String
        let resolvedId: String
        let givenUrl: String
        let givenTitle: String
        let favorite: Favorite
        let status: Status
        let timeAdded: String
        let timeUpdated: String
        let timeRead: String
        let timeFavorited: String
        let sortId: Int
        let resolvedTitle: String
        let resolvedUrl: String
        let excerpt: String
        let isArticle: String
        let isIndex: String
        let hasVideo: String
        let hasImage: String
        let wordCount: String
        let lang: String
        let ampUrl: String?
        let timeToRead: Int?
        let topImageUrl: String?
        let listenDurationEstimate: Int

        // DetailType: Complete
        let tags: [String: Tag]?
        let authors: [String: Author]?
        let image: Image?
        let images: [String: Image]?
        let videos: [String: Video]?
        let domainMetadata: DomainMetadata?
        
        enum Favorite: String, Codable {
            case unfavorited = "0"
            case favorited = "1"
        }
        
        enum Status: String, Codable {
            case unread = "0"
            case archived = "1"
            case deleted = "2"
        }
        
        struct Tag: Codable {
            let itemId: String
            let tag: String
        }
        
        struct Author: Codable {
            let itemId: String
            let authorId: String
            let name: String
            let url: String
        }
        
        struct Image: Codable {
            
            // Key: image
            let itemId: String
            let src: String
            let width: String
            let height: String
            
            // Key: images
            let imageId: String?
            let credit: String?
            let caption: String?
        }
        
        struct Video: Codable {
            let itemId: String
            let videoId: String
            let src: String
            let width: String
            let height: String
            let type: String
            let vid: String
            let length: String
        }
        
        struct DomainMetadata: Codable {
            let name: String?
            let logo: String
            let greyscaleLogo: String
        }
    }
}

extension PocketService.Item: Identifiable {
    var id: String { itemId }
}
