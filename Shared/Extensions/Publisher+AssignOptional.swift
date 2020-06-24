import Combine

extension Publisher where Failure == Never {
    public func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output?>, on object: Root) -> AnyCancellable {
        return self.sink(receiveValue: { object[keyPath: keyPath] = $0 })
    }
}
