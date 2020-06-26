import SwiftUI
import FullScreenSafariView

struct ItemList: View {
    
    @EnvironmentObject var pouchModel: PouchModel
    
    @AppStorage(AppStorageKey.entersReaderIfAvailable.rawValue) var entersReaderIfAvailable: Bool = false
    @AppStorage(AppStorageKey.itemsGroupingKey.rawValue) var itemsGroupingKey: DatedItemGroup.GroupingKey = .timeAdded
    
    @State private var selectedURL: URL?
    
    var datedItemGroups: [DatedItemGroup] {
        DatedItemGroup.groupItems(items: pouchModel.items, by: itemsGroupingKey, sorting: .descending)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(datedItemGroups) { group in
                    Section(header: Text(Utility.dateString(from: group.date))) {
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
