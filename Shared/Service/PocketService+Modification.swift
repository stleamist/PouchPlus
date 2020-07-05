import Foundation
import Combine
import Alamofire

extension PocketService {
    
    func modificationPublisher(accessToken: String, query: ModificationQuery) -> AnyPublisher<Result<ModificationContent, AFError>, Never> {
        return session.request(
            baseURL.appendingPathComponent("/send"),
            method: .post,
            parameters: query,
            encoder: snakeCaseParameterEncoder,
            interceptor: AuthenticationInterceptor(consumerKey: consumerKey, accessToken: accessToken)
        )
        .publishDecodable(type: ModificationContent.self, decoder: decoder)
        .result()
        .eraseToAnyPublisher()
    }
    
    struct ModificationQuery: Encodable {
        let actions: [Action]
        
        enum Action: Encodable {
            
            // Basic Actions
            case add(query: AddingQuery)
            case archive(query: ArchivingQuery)
            case readd(query: ReaddingQuery)
            case favorite(query: FavoritingQuery)
            case unfavorite(query: UnfavoritingQuery)
            case delete(query: DeletingQuery)
            
            // Tagging Actions
            case tagsAdd(query: TagsAddingQuery)
            case tagsRemove(query: TagsRemovingQuery)
            case tagsReplace(query: TagsReplacingQuery)
            case tagsClear(query: TagsClearingQuery)
            case tagRename(query: TagsRenamingQuery)
            case tagDelete(query: TagsDeletingQuery)
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .add(let query): try container.encode(query)
                case .archive(let query): try container.encode(query)
                case .readd(let query): try container.encode(query)
                case .favorite(let query): try container.encode(query)
                case .unfavorite(let query): try container.encode(query)
                case .delete(let query): try container.encode(query)
                case .tagsAdd(let query): try container.encode(query)
                case .tagsRemove(let query): try container.encode(query)
                case .tagsReplace(let query): try container.encode(query)
                case .tagsClear(let query): try container.encode(query)
                case .tagRename(let query): try container.encode(query)
                case .tagDelete(let query): try container.encode(query)
                }
            }
        }
        
        struct AddingQuery: Encodable {
            let action: String = "add"
            let itemId: Int
            var refId: Int? = nil
            var tags: String? = nil
            var time: TimeInterval? = nil
            var title: String? = nil
            var url: URL? = nil
        }
        
        struct ArchivingQuery: Encodable {
            let action: String = "archive"
            let itemId: String
            var time: TimeInterval?
        }
        
        struct ReaddingQuery: Encodable {
            let action: String = "readd"
            let itemId: String
            var time: TimeInterval?
        }
        
        struct FavoritingQuery: Encodable {
            let action: String = "favorite"
            let itemId: String
            var time: TimeInterval?
        }
        
        struct UnfavoritingQuery: Encodable {
            let action: String = "unfavorite"
            let itemId: String
            var time: TimeInterval?
        }
        
        struct DeletingQuery: Encodable {
            let action: String = "delete"
            let itemId: String
            var time: TimeInterval?
        }
        
        struct TagsAddingQuery: Encodable {
            let action: String = "tags_add"
            let itemId: String
            let tags: String
            var time: TimeInterval?
        }
        
        struct TagsRemovingQuery: Encodable {
            let action: String = "tags_remove"
            let itemId: String
            let tags: String
            var time: TimeInterval?
        }
        struct TagsReplacingQuery: Encodable {
            let action: String = "tags_replace"
            let itemId: String
            let tags: String
            var time: TimeInterval?
        }
        
        struct TagsClearingQuery: Encodable {
            let action: String = "tags_clear"
            let itemId: String
            var time: TimeInterval?
        }
        
        struct TagsRenamingQuery: Encodable {
            let action: String = "tags_rename"
            let oldTag: String
            let newTag: String
            var time: TimeInterval?
        }
        
        struct TagsDeletingQuery: Encodable {
            let action: String = "tags_delete"
            let tag: String
            var time: TimeInterval?
        }
    }

    struct ModificationContent: Decodable {
        // TODO: action_results 응답 객체 타입 구현하기
//        let actionResults: [Bool]
//        let actionErrors: [Any]
        let status: Int
    }
}
