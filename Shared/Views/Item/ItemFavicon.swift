import SwiftUI
import KingfisherSwiftUI

struct ItemFavicon: View {
    
    var logoURL: URL?
    var pageURL: URL?
    
    @State private var imageNotFound = false
    
    private var showsImage: Bool {
        return (logoURL != nil || pageURL != nil) && (!imageNotFound)
    }
    
    private var imageView: KFImage {
        if let logoURL = logoURL {
            return KFImage(logoURL)
        } else if let pageURL = pageURL {
            return KFImage(source: .provider(KFFaviconProvider(url: pageURL)))
        } else {
            return KFImage(nil)
        }
    }
    
    var body: some View {
        Group {
            if showsImage {
                imageView
                    .onFailure { _ in imageNotFound = true }
                    .cancelOnDisappear(true)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .background(Color(.systemGray6))
            } else {
                Color.clear
            }
        }
    }
}

struct ItemFavicon_Previews: PreviewProvider {
    static var previews: some View {
        ItemFavicon(pageURL: URL(string: "https://www.apple.com/")!)
    }
}
