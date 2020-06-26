import Foundation
import KeychainAccess

@propertyWrapper
struct KeychainStorage<Value: Codable> {
    
    let key: String
    let service: String
    let defaultValue: Value
    
    private let keychain: KeychainAccess.Keychain
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(
        _ key: String,
        service: String = (Bundle.main.bundleIdentifier ?? "KeychainAccess"),
        defaultValue: Value
    ) {
        self.key = key
        self.service = service
        self.defaultValue = defaultValue
        self.keychain = KeychainAccess.Keychain(service: service)
    }

    var wrappedValue: Value {
        get {
            guard let data = try? keychain.getData(key),
                let value = try? decoder.decode(Value.self, from: data) else {
                return defaultValue
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
