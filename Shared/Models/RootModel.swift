import Foundation

class RootModel: ObservableObject {
    @KeychainStorage("accessTokenContent", defaultValue: nil) private(set) var accessTokenResponse: PocketService.AccessTokenContent? {
        willSet {
            // @KeychainStorage와 동시에 사용할 수 없는 @Published 프로퍼티 래퍼를 대신하여
            // objectWillChange.send()를 수동으로 호출한다.
            self.objectWillChange.send()
        }
    }
}

extension RootModel {
    func setAccessTokenResponse(_ accessTokenResponse: PocketService.AccessTokenContent) {
        self.accessTokenResponse = accessTokenResponse
    }
    func removeAccessTokenResponse() {
        self.accessTokenResponse = nil
    }
}
