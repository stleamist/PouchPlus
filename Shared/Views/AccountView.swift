import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var rootModel: RootModel
    
    @AppStorage(AppStorageKey.entersReaderIfAvailable.rawValue) var entersReaderIfAvailable: Bool = false
    @AppStorage(AppStorageKey.itemsGroupingKey.rawValue) var itemsGroupingKey: DatedItemGroup.GroupingKey = .timeAdded
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ValueLabel(title: "Username", value: rootModel.accessTokenResponse?.username ?? "")
                }
                Section {
                    Toggle("Enters Reader If Available", isOn: $entersReaderIfAvailable)
                }
                Section(header: Text("Viewing")) {
                    Picker(selection: $itemsGroupingKey, label: Text("Sort Items By")) {
                        ForEach(DatedItemGroup.GroupingKey.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                Section {
                    Button(action: rootModel.removeAccessTokenResponse) {
                        Text("Log Out")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Account")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
