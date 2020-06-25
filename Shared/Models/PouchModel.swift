import Combine
import Alamofire

class PouchModel: ObservableObject {
    
    private let accessTokenResponse: PocketService.AccessTokenResponse
    
    init(accessTokenResponse: PocketService.AccessTokenResponse) {
        self.accessTokenResponse = accessTokenResponse
    }
}
