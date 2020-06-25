import Combine
import Alamofire

class MainModel: ObservableObject {
    
    private let accessTokenResponse: PocketService.AccessTokenResponse
    
    init(accessTokenResponse: PocketService.AccessTokenResponse) {
        self.accessTokenResponse = accessTokenResponse
    }
}
