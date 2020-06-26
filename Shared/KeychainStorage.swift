import Foundation
import KeychainAccess

// Value가 Optional이고 initialValue가 Non-optional 값일 때
// 런타임 도중 nil 값을 할당하면 다음 실행에서 키체인이 데이터가 없다고 판단, initialValue를 할당할 것이라는 오작동을 예상했으나
// 확인해본 결과 그렇지 않고 정상적으로 작동한다.

@propertyWrapper
struct KeychainStorage<Value: Codable> {
    
    let key: String
    let service: String
    let initialValue: Value
    
    private let keychain: KeychainAccess.Keychain
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(wrappedValue initialValue: Value, _ key: String, service: String? = nil) {
        self.initialValue = initialValue
        self.key = key
        self.service = service ?? Bundle.main.bundleIdentifier ?? "com.kishikawakatsumi.KeychainAccess"
        self.keychain = KeychainAccess.Keychain(service: self.service)
    }

    var wrappedValue: Value {
        get {
            guard let data = try? keychain.getData(key),
                let value = try? decoder.decode(Value.self, from: data) else {
                return initialValue
            }
            return value
        }
        set {
            guard let newData = try? encoder.encode(newValue) else {
                return
            }
            try? keychain.set(newData, key: key)
        }
    }
}
