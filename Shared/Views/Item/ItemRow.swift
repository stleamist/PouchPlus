import SwiftUI

struct ItemRow: View {
    
    var item: PocketService.Item
    
    var title: String {
        return (!item.resolvedTitle.isEmpty) ? item.resolvedTitle : item.givenTitle
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ItemThumbnail(
                imageURL: item.topImageUrl?.toURL(addPercentEncoding: true),
                logoURL: item.domainMetadata?.logo.toURL(addPercentEncoding: true),
                pageURL: item.resolvedUrl.toURL(addPercentEncoding: true) ?? item.givenUrl.toURL(addPercentEncoding: true),
                title: item.resolvedTitle
            )
                .padding(.top, 3)
            
            VStack(alignment: .leading, spacing: UIFontMetrics(forTextStyle: .subheadline).scaledValue(for: 4)) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(item.resolvedUrl.toURL(addPercentEncoding: true)?.host ?? "")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(item.excerpt)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 3)
    }
}

//struct ItemRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRow(item: <#PocketService.Item#>)
//    }
//}
