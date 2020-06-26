import Foundation
import KeychainAccess

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
