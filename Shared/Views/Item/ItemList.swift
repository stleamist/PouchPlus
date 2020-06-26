import SwiftUI
import FullScreenSafariView

struct ItemList: View {
    
    @EnvironmentObject var pouchModel: PouchModel
    
    @AppStorage(AppStorageKey.entersReaderIfAvailable.rawValue) var entersReaderIfAvailable: Bool = false
    @AppStorage(AppStorageKey.itemsGroupingKey.rawValue) var itemsGroupingKey: DatedItemGroup.GroupingKey = .timeAdded
    
    @State private var selectedURL: URL?
    
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
                                        self.selectedURL = item.resolvedUrl.toURL() ?? item.givenUrl.toURL()
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
            .safariView(item: $selectedURL) { selectedURL in
                SafariView(
                    url: selectedURL,
                    configuration: .init(
                        entersReaderIfAvailable: entersReaderIfAvailable
                    )
                )
            }
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList()
    }
}
