import SwiftUI
import FullScreenSafariView

struct ItemList: View {
    
    @EnvironmentObject var pouchModel: PouchModel
    
    @AppStorage(AppStorageKey.useReaderWhenAvailable.rawValue) var useReaderWhenAvailable: Bool = false
    @AppStorage(AppStorageKey.itemsGroupingKey.rawValue) var itemsGroupingKey: DatedItemGroup.GroupingKey = .timeAdded
    
    @State private var selectedURL: URL?
    
    // TODO: 모델에서 유래된 @State들을 모델로 옮기기
    @State private var loadingError: PouchPlusError?
    
    var datedItemGroups: [DatedItemGroup] {
        DatedItemGroup.groupItems(items: pouchModel.items, by: itemsGroupingKey)
    }
    
    var body: some View {
        NavigationView {
            Group {
                // TODO: 궁극적으로 UIRefreshControl 사용하기
                if datedItemGroups.isEmpty {
                    HStack(spacing: 8) {
                        ProgressView()
                        Text("Loading...")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(datedItemGroups) { group in
                            Section(header: Text(group.date, style: .date)) {
                                ForEach(group.items) { item in
                                    Button(action: {
                                        self.selectedURL = item.resolvedUrl.toURL(addPercentEncoding: true) ?? item.givenUrl.toURL(addPercentEncoding: true)
                                    }) {
                                        ItemRow(item: item)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Items")
            .onAppear {
                pouchModel.loadItems(query: .init())
            }
            .onReceive(pouchModel.$latestRetrievalResult) { result in
                if case .failure(let error) = result {
                    self.loadingError = error
                }
            }
            .alert(error: $loadingError)
            .safariView(item: $selectedURL) { selectedURL in
                SafariView(
                    url: selectedURL,
                    configuration: .init(
                        entersReaderIfAvailable: useReaderWhenAvailable
                    )
                )
                .preferredControlTintColor(Asset.accentColor)
            }
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList()
    }
}
