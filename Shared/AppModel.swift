import Foundation

class AppModel: ObservableObject {
    @Published private(set) var accessTokenResponse: PocketService.AccessTokenResponse?
}

extension AppModel {
    func setAccessTokenResponse(_ accessTokenResponse: PocketService.AccessTokenResponse) {
        self.accessTokenResponse = accessTokenResponse
    }
}
