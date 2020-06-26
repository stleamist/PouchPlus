import Foundation

class RootModel: ObservableObject {
    @KeychainStorage(.accessTokenContent) private(set) var accessTokenContent: PocketService.AccessTokenContent? = nil {
        willSet {
            // @KeychainStorage와 동시에 사용할 수 없는 @Published 프로퍼티 래퍼를 대신하여
            // objectWillChange.send()를 수동으로 호출한다.
            self.objectWillChange.send()
        }
    }
}

extension RootModel {
    func setAccessTokenContent(_ accessTokenContent: PocketService.AccessTokenContent) {
        self.accessTokenContent = accessTokenContent
    }
    func removeAccessTokenContent() {
        self.accessTokenContent = nil
    }
}
