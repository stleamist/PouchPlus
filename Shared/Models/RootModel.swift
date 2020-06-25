import Foundation

class RootModel: ObservableObject {
    @Published private(set) var accessTokenResponse: PocketService.AccessTokenContent?
}

extension RootModel {
    func setAccessTokenResponse(_ accessTokenResponse: PocketService.AccessTokenContent) {
        self.accessTokenResponse = accessTokenResponse
    }
}
