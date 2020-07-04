import SwiftUI

struct UnreadIndicator: View {
    
    @ScaledMetric private var length: CGFloat = 10
    
    var body: some View {
        Circle()
            .fill(Color.accentColor)
            .frame(width: length, height: length)
    }
}

struct FavoritedIndicator: View {
    var body: some View {
        Image(systemName: "star.fill")
            .font(Font.subheadline.weight(.regular))
            .foregroundColor(.yellow)
    }
}

struct TagToken: View {
    
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.accentColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 1.5)
            .background(Color.accentColor.opacity(0.1).cornerRadius(4))
    }
}

struct ItemRow: View {
    
    // TODO: pouchModel을 로우 안에서도 접근하는 것이 맞나? 아니면 상위 뷰에 위임해야 할까?
    @EnvironmentObject var pouchModel: PouchModel
    
    // MARK: Metadata
    
    var item: PocketService.Item
    
    private var title: String {
        return (!item.resolvedTitle.isEmpty) ? item.resolvedTitle : item.givenTitle
    }
    
    private var url: URL? {
        let urlString = (!item.resolvedUrl.isEmpty) ? item.resolvedUrl : item.givenUrl
        return urlString.toURL(addPercentEncoding: true)
    }
    
    private var excerpt: String {
        return item.excerpt
    }
    
    private var logoURL: URL? {
        return item.domainMetadata?.logo.toURL(addPercentEncoding: true)
    }
    
    private var imageURL: URL? {
        return item.topImageUrl?.toURL(addPercentEncoding: true)
    }
    
    private var tags: [String] {
        return item.tags?.map { $1.tag } ?? []
    }
    
    // MARK: Metrics
    
    @ScaledMetric private var seperatorInset: CGFloat = 32
    @ScaledMetric private var accessoryContainerLength: CGFloat = 18
    @ScaledMetric private var faviconLength: CGFloat = 16
    
    @ScaledMetric private var thumbnailLength: CGFloat = 72
    
    @ScaledMetric private var horizontalPadding: CGFloat = 12
    @ScaledMetric private var verticalPadding: CGFloat = 8
    @ScaledMetric private var horizontalSpacing: CGFloat = 12
    @ScaledMetric private var verticalSpacing: CGFloat = 4
    @ScaledMetric private var thumbnailTopPadding: CGFloat = 6
    @ScaledMetric private var tagSpacing: CGFloat = 6
    
    // MARK: Indicators
    
    private var indicators: [AnyView] {
        var views: [AnyView] = []
        if item.status == .unread {
            views.append(AnyView(UnreadIndicator()))
        }
        if item.favorite == .favorited {
            views.append(AnyView(FavoritedIndicator()))
        }
        return views
    }
    
    private var firstIndicator: some View {
        Group {
            if let firstIndicator = indicators[safe: 0] {
                firstIndicator
            } else {
                Color.clear // EmptyView()를 사용하면 리딩 여백을 사용할 수 없다.
                    .frame(width: 0, height: 0) // 프레임을 지정하지 않으면 높이가 무한대로 늘어난다.
            }
        }
    }
    
    private var secondIndicator: some View {
        Group {
            if let secondIndicator = indicators[safe: 1] {
                secondIndicator
            } else {
                Color.clear
                    .frame(width: 0, height: 0)
            }
        }
    }
    
    // MARK: Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            HStack(alignment: .disclosureIndicator, spacing: 0) {
                ItemFavicon(logoURL: logoURL, pageURL: url)
                    .frame(width: faviconLength, height: faviconLength)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .frame(width: seperatorInset)
                    .alignmentGuide(.disclosureIndicator, computeValue: { d in d[VerticalAlignment.center] })
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.label))
                        .lineLimit(2)
                    Spacer(minLength: horizontalSpacing)
                    Text(Image(systemName: "chevron.right"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(.tertiaryLabel))
                        .alignmentGuide(.disclosureIndicator, computeValue: { d in d[VerticalAlignment.center] })
                }
            }
            HStack(alignment: .top, spacing: horizontalSpacing) {
                VStack(alignment: .leading, spacing: verticalSpacing) {
                    HStack(alignment: .center, spacing: 0) {
                        firstIndicator
                            .frame(width: seperatorInset)
                        Text(url?.host ?? "")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color(.label))
                            .lineLimit(1)
                    }
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        secondIndicator
                            .frame(width: seperatorInset)
                        VStack(alignment: .leading, spacing: verticalSpacing) {
                            Text(excerpt)
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(Color(.secondaryLabel))
                                .lineLimit(tags.isEmpty ? 3 : 2)
                                .fixedSize(horizontal: false, vertical: true) // Force enable lineLimit
                            ScrollView(.horizontal) {
                                HStack(spacing: tagSpacing) {
                                    ForEach(tags, id: \.self) { tag in
                                        TagToken(tag)
                                    }
                                }
                            }
                        }
                    }
                }
                ItemThumbnail(url: imageURL)
                    .frame(width: min(thumbnailLength, 72), height: min(thumbnailLength, 72))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(.top, thumbnailTopPadding)
                    .padding(.bottom, verticalSpacing)
            }
        }
        .padding(.trailing, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .contextMenu {
            if item.status != .archived {
                Button(action: archiveItem) {
                    Label("Archive", systemImage: "archivebox")
                }
            } else {
                Button(action: readdItem){
                    Label("Unarchive", systemImage: "plus")
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

private extension VerticalAlignment {
    private enum DisclosureIndicatorAlignment: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[VerticalAlignment.center]
        }
    }
    static let disclosureIndicator = VerticalAlignment(DisclosureIndicatorAlignment.self)
}

struct ItemRow_Previews: PreviewProvider {
    
    static let sampleItem: PocketService.Item = .init(
        title: "Thoughts on Flash",
        host: "https://www.apple.com/",
        body: "Apple has a long relationship with Adobe. In fact, we met Adobe’s founders when they were in their proverbial garage.",
        tags: ["apple", "ipad", "adobe", "flash"]
    )
    
    static let sizeCategories: [ContentSizeCategory] = [
        .extraSmall,
        .medium,
        .extraExtraExtraLarge,
//        .accessibilityLarge
    ]
    
    static var previews: some View {
        Group {
            ForEach(sizeCategories, id: \.self) { sizeCategory in
                ItemRow(item: sampleItem)
                    .environment(\.sizeCategory, sizeCategory)
                    .previewDisplayName(String(describing: sizeCategory))
            }
        }
        .previewLayout(.sizeThatFits)
    }
}

private extension PocketService.Item {
    init(title: String, host: String, body: String, tags tagsArray: [String]) {
        let tagsDictionary = Dictionary(uniqueKeysWithValues: tagsArray.map { ($0, PocketService.Item.Tag(itemId: "", tag: $0) ) })
        self.init(itemId: "", resolvedId: "", givenUrl: host, givenTitle: title, favorite: .favorited, status: .unread, timeAdded: "", timeUpdated: "", timeRead: "", timeFavorited: "", sortId: 0, resolvedTitle: title, resolvedUrl: host, excerpt: body, isArticle: "", isIndex: "", hasVideo: "", hasImage: "", wordCount: "", lang: "", ampUrl: nil, timeToRead: nil, topImageUrl: "https://www.apple.com/newsroom/images/live-action/wwdc-2020/Apple_WWDC20-keynote-tim-cook_06222020_big.jpg.large_2x.jpg", listenDurationEstimate: 0, tags: tagsDictionary, authors: nil, image: nil, images: nil, videos: nil, domainMetadata: nil)
    }
}
