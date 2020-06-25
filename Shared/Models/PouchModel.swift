import Combine
import Alamofire

class PouchModel: ObservableObject {
    
    private let accessTokenContent: PocketService.AccessTokenContent
    
    init(accessTokenContent: PocketService.AccessTokenContent) {
        self.accessTokenContent = accessTokenContent
    }
}
