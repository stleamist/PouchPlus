import Foundation
import Kingfisher
import FavIcon

struct KFFaviconProvider: ImageDataProvider {
    
    let url: URL
    let cacheKey: String
    
    init(url: URL, cacheKey: String? = nil) {
        self.url = url
        self.cacheKey = cacheKey ?? url.absoluteString
    }

    func data(handler: @escaping (Result<Data, Error>) -> Void) {
        
        do {
            try FavIcon.downloadPreferred(url) { result in
                switch result {
                case .success(let image):
                    guard let data = image.pngData() ?? image.jpegData(compressionQuality: 1) else {
                        return
                    }
                    handler(.success(data))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        } catch {
            handler(.failure(error))
        }
    }
}
