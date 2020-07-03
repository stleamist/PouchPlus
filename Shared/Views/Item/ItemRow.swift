import SwiftUI

struct ItemRow: View {
    
    var item: PocketService.Item
    
    var title: String {
        return (!item.resolvedTitle.isEmpty) ? item.resolvedTitle : item.givenTitle
    }
    
    @AppStorage(AppStorageKey.archiveItemsOnOpen.rawValue) var archiveItemsOnOpen: Bool = false
    
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
        .contextMenu {
            if item.status != .archived {
                Button {
                    
                } label: {
                    if archiveItemsOnOpen {
                        Label("Mark as Read", systemImage: "circle")
                    } else {
                        Label("Archive", systemImage: "archivebox")
                    }
                }
            } else {
                Button {
                    
                } label: {
                    if archiveItemsOnOpen {
                        Label("Mark as Unread", systemImage: "circle.fill")
                    } else {
                        Label("Unarchive", systemImage: "plus")
                    }
                }
            }
            if item.favorite != .favorited {
                Button {
                    
                } label: {
                    Label("Favorite", systemImage: "star")
                }
            } else {
                Button {
                    
                } label: {
                    Label("Unfavorite", systemImage: "star.slash")
                }
            }
            Button {
                
            } label: {
                Label("Edit Tags...", systemImage: "tag")
            }
            Button {
                
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

//struct ItemRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRow(item: <#PocketService.Item#>)
//    }
//}
