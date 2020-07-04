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
        VStack(alignment: .leading, spacing: verticalSpacing) {
            HStack(alignment: .disclosureIndicator, spacing: 0) {
                Color(.systemTeal)
                    .cornerRadius(2)
                    .frame(width: faviconLength, height: faviconLength)
                    .frame(width: seperatorInset)
                    .alignmentGuide(.disclosureIndicator, computeValue: { d in d[VerticalAlignment.center] })
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("The Quick Brown Fox Jumps over the Lazy Dog")
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
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: unreadBadgeLength, height: unreadBadgeLength)
                            .frame(width: seperatorInset)
                        Text("www.apple.com")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color(.label))
                            .lineLimit(1)
                    }
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Image(systemName: "star.fill")
                            .font(Font.subheadline.weight(.regular))
                            .foregroundColor(.yellow)
                            .frame(width: seperatorInset)
                        VStack(alignment: .leading, spacing: verticalSpacing) {
                            Text("Apple has a long relationship with Adobe. In fact, we met Adobe’s founders when they were in their proverbial garage.")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(Color(.secondaryLabel))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true) // Force enable lineLimit
                            ScrollView(.horizontal) {
                                HStack(spacing: tagSpacing) {
                                    TagToken("apple")
                                    TagToken("ipad")
                                    TagToken("adobe")
                                    TagToken("flash")
                                }
                            }
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
        .padding(.vertical, verticalPadding)
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
