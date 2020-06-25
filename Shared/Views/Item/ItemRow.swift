import SwiftUI

struct ItemRow: View {
    
    var item: PocketService.Item
    
    var title: String {
        return (!item.resolvedTitle.isEmpty) ? item.resolvedTitle : item.givenTitle
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ItemThumbnail(
                imageURL: item.topImageUrl?.toURL(),
                logoURL: item.domainMetadata?.logo.toURL(),
                pageURL: item.resolvedUrl.toURL() ?? item.givenUrl.toURL(),
                title: item.resolvedTitle
            )
                .padding(.top, 3)
            
            VStack(alignment: .leading, spacing: UIFontMetrics(forTextStyle: .subheadline).scaledValue(for: 4)) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(item.resolvedUrl.toURL()?.host ?? "")
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
