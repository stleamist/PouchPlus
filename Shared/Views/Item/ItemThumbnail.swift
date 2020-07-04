import SwiftUI
import KingfisherSwiftUI

struct ItemThumbnail: View {
    
    var url: URL?
    
    @State private var imageNotFound = false
    
    private var showsImage: Bool {
        return (url != nil) && (!imageNotFound)
    }
    
    var body: some View {
        Group {
            if showsImage {
                KFImage(url)
                    .onFailure { _ in imageNotFound = true }
                    .cancelOnDisappear(true)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .background(Color(.systemGray6))
            } else {
                EmptyView()
            }
        }
    }
}

struct ItemThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ItemThumbnail(url: URL(string: "https://www.apple.com/newsroom/images/live-action/wwdc-2020/Apple_WWDC20-keynote-tim-cook_06222020_big.jpg.large_2x.jpg"))
            ItemThumbnail(url: URL(string: "https://www.apple.com/newsroom/images/live-action/wwdc-2020/Apple_WWDC20-keynote-tim-cook_06222020_big.jpg.large_3x.jpg"))
        }
            .previewLayout(.sizeThatFits)
    }
}
