import SwiftUI
import FullScreenSafariView

struct ItemList: View {
    
    @EnvironmentObject var pouchModel: PouchModel
    
    @State private var selectedURL: URL?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(pouchModel.items) { item in
                    Button(action: {
                        self.selectedURL = item.resolvedUrl.toURL() ?? item.givenUrl.toURL()
                    }) {
                        ItemRow(item: item)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Items")
            .onAppear {
                pouchModel.loadItems(query: .init())
            }
            .safariView(item: $selectedURL) { selectedURL in
                SafariView(url: selectedURL)
            }
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    static var previews: some View {
        ItemList()
    }
}
