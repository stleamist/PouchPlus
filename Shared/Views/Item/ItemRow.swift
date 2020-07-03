import SwiftUI

struct ItemRow: View {
    
    // TODO: pouchModel을 로우 안에서도 접근하는 것이 맞나? 아니면 상위 뷰에 위임해야 할까?
    @EnvironmentObject var pouchModel: PouchModel
    
    @AppStorage(AppStorageKey.archiveItemsOnOpen.rawValue) var archiveItemsOnOpen: Bool = false
    @ScaledMetric(relativeTo: .subheadline) var spacing: CGFloat = 4
    
    var item: PocketService.Item
    
    var title: String {
        return (!item.resolvedTitle.isEmpty) ? item.resolvedTitle : item.givenTitle
    }
    
    // TODO: 로우 디자인 개선하기
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ItemThumbnail(
                imageURL: item.topImageUrl?.toURL(addPercentEncoding: true),
                logoURL: item.domainMetadata?.logo.toURL(addPercentEncoding: true),
                pageURL: item.resolvedUrl.toURL(addPercentEncoding: true) ?? item.givenUrl.toURL(addPercentEncoding: true),
                title: item.resolvedTitle
            )
                .padding(.top, 3)
            
            VStack(alignment: .leading, spacing: spacing) {
                HStack(alignment: .top) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    Spacer()
                    if item.favorite == .favorited {
                        Image(systemName: "star.fill")
                            .renderingMode(.original)
                            .imageScale(.small)
                            .font(.subheadline)
                    }
                    if item.status == .unread {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.blue)
                            .imageScale(.small)
                            .font(.footnote)
                    }
                }
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
                Button(action: archiveItem) {
                    if archiveItemsOnOpen {
                        Label("Mark as Read", systemImage: "circle")
                    } else {
                        Label("Archive", systemImage: "archivebox")
                    }
                }
            } else {
                Button(action: readdItem){
                    if archiveItemsOnOpen {
                        Label("Mark as Unread", systemImage: "circle.fill")
                    } else {
                        Label("Unarchive", systemImage: "plus")
                    }
                }
            }
            if item.favorite != .favorited {
                Button(action: favoriteItem) {
                    Label("Favorite", systemImage: "star")
                }
            } else {
                Button(action: unfavoriteItem) {
                    Label("Unfavorite", systemImage: "star.slash")
                }
            }
            Divider()
            Button(action: {}) {
                Label("Edit Tags...", systemImage: "tag")
            }
            Divider()
            Button(action: deleteItem) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func archiveItem() {
        pouchModel.archiveItems(queries: [.init(itemId: item.itemId)])
    }
    
    private func readdItem() {
        pouchModel.readdItems(queries: [.init(itemId: item.itemId)])
    }
    
    private func favoriteItem() {
        pouchModel.favoriteItems(queries: [.init(itemId: item.itemId)])
    }
    
    private func unfavoriteItem() {
        pouchModel.unfavoriteItems(queries: [.init(itemId: item.itemId)])
    }
    
    private func deleteItem() {
        pouchModel.deleteItems(queries: [.init(itemId: item.itemId)])
    }
}

//struct ItemRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRow(item: <#PocketService.Item#>)
//    }
//}
