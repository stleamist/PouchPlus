import Foundation

extension String {
    
    func toURL(addPercentEncoding: Bool = false) -> URL? {
        if addPercentEncoding {
            return URL.percentEncoded(string: self)
        } else {
            return URL(string: self)
        }
    }
}

extension URL {
    
    init?(string: String?) {
        guard let string = string else {
            return nil
        }
        self.init(string: string)
    }
    
    static func percentEncoded(string: String?) -> URL? {
        self.init(string: string?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
    }
}
