import SwiftUI
import FullScreenSafariView

struct ItemList: View {
    
    @EnvironmentObject var pouchModel: PouchModel
    
    @AppStorage(AppStorageKey.useReaderWhenAvailable.rawValue) var useReaderWhenAvailable: Bool = false
    @AppStorage(AppStorageKey.itemsGroupingKey.rawValue) var itemsGroupingKey: DatedItemGroup.GroupingKey = .timeAdded
    
    @State private var selectedURL: URL?
    @State private var showingItemEditView = false
    
    // TODO: 모델에서 유래된 @State들을 모델로 옮기기
    @State private var loadingError: PouchPlusError?
    @State private var additionError: PouchPlusError?
    @State private var modificationError: PouchPlusError?
    
    var datedItemGroups: [DatedItemGroup] {
        DatedItemGroup.groupItems(items: pouchModel.items, by: itemsGroupingKey)
    }
    
    var body: some View {
        NavigationView {
            Group {
                // TODO: 궁극적으로 UIRefreshControl 사용하기
                if datedItemGroups.isEmpty {
                    VStack(spacing: 8) {
                        ProgressView()
                        Text("LOADING")
                            .font(.subheadline)
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
                                .onDelete { indexSet in
                                    let items = indexSet.map { group.items[$0] }
                                    let queries = items.map { PocketService.ModificationQuery.DeletingQuery(itemId: $0.itemId) }
                                    pouchModel.deleteItems(queries: queries)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showingItemEditView = true
                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                }
            }
            .safariView(item: $selectedURL) { selectedURL in
                SafariView(
                    url: selectedURL,
                    configuration: .init(
                        entersReaderIfAvailable: useReaderWhenAvailable
                    )
                )
                .preferredControlTintColor(Asset.accentColor)
            }
            .sheet(isPresented: $showingItemEditView) {
                ItemEditView(mode: .add)
                    .environmentObject(pouchModel)
            }
            .onAppear(perform: retrieveItems)
            .onReceive(pouchModel.$latestRetrievalResult) { result in
                if case .failure(let error) = result {
                    self.loadingError = error
                }
            }
            .onReceive(pouchModel.$latestAdditionResult) { result in
                switch result {
                case .success:
                    retrieveItems()
                case .failure(let error):
                    self.additionError = error
                case .none:
                    ()
                }
            }
            .onReceive(pouchModel.$latestModificationResult) { result in
                switch result {
                case .success:
                    retrieveItems()
                case .failure(let error):
                    self.modificationError = error
                case .none:
                    ()
                }
            }
            .background(Group {
                Color.clear
                    .alert(error: $loadingError)
                Color.clear
                    .alert(error: $additionError)
                Color.clear
                    .alert(error: $modificationError)
            })
        }
    }
    
    private func retrieveItems() {
        pouchModel.retrieveItems(query: .init())
    }
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList()
    }
}
