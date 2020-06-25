import SwiftUI
import KingfisherSwiftUI

struct ItemThumbnail: View {
    
    var imageURL: URL?
    var logoURL: URL?
    var pageURL: URL?
    var title: String
    
    @State private var shouldShowIcon = false
    
    var body: some View {
        imageView
            .cancelOnDisappear(true)
            .resizable()
            .renderingMode(.original)
            .placeholder {
                ZStack {
                    Color(.systemGray3)
                    Text(title.first?.uppercased() ?? "").font(.system(size: 44, weight: .light)).foregroundColor(.white)
                }
            }
            .aspectRatio(contentMode: .fill)
            .background(Color(.systemGray6))
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .circular))
    }
    
    var imageView: KFImage {
        if !shouldShowIcon {
            return KFImage(imageURL ?? logoURL)
                .onFailure { _ in self.shouldShowIcon = true }
        } else {
            guard let pageURL = pageURL else {
                return KFImage(source: nil)
            }
            return KFImage(source: .provider(KFFaviconProvider(url: pageURL)))
        }
    }
}

struct ItemThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        ItemThumbnail(title: "Title")
    }
}
