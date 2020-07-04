import Foundation

enum AppStorageKey: String {
    case itemsGroupingKey
    case useReaderWhenAvailable
}

enum KeychainStorageKey: String {
    case accessTokenContent
}

// TODO: AppStorage도 같은 방법으로 enum 키를 받도록 확장하기
// 현재는 extension에서 시스템 이니셜라이저를 사용할 수 없는 문제가 있음.

extension KeychainStorage {
    init(wrappedValue: Value, _ key: KeychainStorageKey, service: String? = nil) {
        self.init(wrappedValue: wrappedValue, key.rawValue, service: service)
    }
}
