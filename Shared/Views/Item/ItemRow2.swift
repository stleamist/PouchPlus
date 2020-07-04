import SwiftUI

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

struct ItemRow2: View {
    
    @ScaledMetric private var seperatorInset: CGFloat = 32
    @ScaledMetric private var accessoryContainerLength: CGFloat = 18
    @ScaledMetric private var faviconLength: CGFloat = 16
    @ScaledMetric private var unreadBadgeLength: CGFloat = 10
    
    @ScaledMetric private var thumbnailLength: CGFloat = 72
    
    @ScaledMetric private var horizontalPadding: CGFloat = 12
    @ScaledMetric private var verticalPadding: CGFloat = 8
    @ScaledMetric private var horizontalSpacing: CGFloat = 12
    @ScaledMetric private var verticalSpacing: CGFloat = 4
    @ScaledMetric private var thumbnailTopPadding: CGFloat = 6
    @ScaledMetric private var tagSpacing: CGFloat = 6
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .center, spacing: verticalSpacing) {
                Group {
                    Color(.systemTeal)
                        .cornerRadius(2)
                        .frame(width: faviconLength, height: faviconLength)
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: unreadBadgeLength, height: unreadBadgeLength)
                    Image(systemName: "star.fill")
                        .font(Font.subheadline.weight(.regular))
                        .foregroundColor(.yellow)
                }
                .frame(
                    width: accessoryContainerLength,
                    height: accessoryContainerLength
                )
            }
            .frame(width: seperatorInset)
            VStack(alignment: .leading, spacing: verticalSpacing) {
                HStack(alignment: .center) {
                    Text("Thoughts on Flash")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.label))
                        .lineLimit(2)
                    Spacer()
                    Text(Image(systemName: "chevron.right"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(.tertiaryLabel))
                }
                HStack(alignment: .top, spacing: horizontalSpacing) {
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        Text("www.apple.com")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color(.label))
                            .lineLimit(1)
                        Text("Apple has a long relationship with Adobe. In fact, we met Adobe’s founders when they were in their proverbial garage.")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color(.secondaryLabel))
                            .lineLimit(2)
                        ScrollView(.horizontal) {
                            HStack(spacing: tagSpacing) {
                                TagToken("apple")
                                TagToken("ipad")
                                TagToken("adobe")
                                TagToken("flash")
                            }
                        }
                    }
                    Color(.tertiarySystemFill)
                        .cornerRadius(4)
                        .frame(width: min(thumbnailLength, 72), height: min(thumbnailLength, 72))
                        .padding(.top, thumbnailTopPadding)
                }
            }
            .padding(.trailing, horizontalPadding)
        }
        .padding(.vertical, verticalPadding)
    }
}

struct ItemRow2_Previews: PreviewProvider {
    
    static let sizeCategories: [ContentSizeCategory] = [
        .extraSmall,
        .medium,
        .extraExtraExtraLarge,
//        .accessibilityLarge
    ]
    
    static var previews: some View {
        Group {
            ForEach(sizeCategories, id: \.self) { sizeCategory in
                ItemRow2()
                    .environment(\.sizeCategory, sizeCategory)
                    .previewDisplayName(String(describing: sizeCategory))
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
