import Foundation

class RootModel: ObservableObject {
    @Published private(set) var accessTokenResponse: PocketService.AccessTokenResponse?
}

extension RootModel {
    func setAccessTokenResponse(_ accessTokenResponse: PocketService.AccessTokenResponse) {
        self.accessTokenResponse = accessTokenResponse
    }
}
