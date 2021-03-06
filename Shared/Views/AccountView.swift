import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var rootModel: RootModel
    
    @AppStorage(AppStorageKey.itemsGroupingKey.rawValue) var itemsGroupingKey: DatedItemGroup.GroupingKey = .timeAdded
    @AppStorage(AppStorageKey.useReaderWhenAvailable.rawValue) var useReaderWhenAvailable: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ValueLabel(title: Text("Username"), value: Text(rootModel.accessTokenContent?.username ?? ""))
                }
                Section(header: Text("Viewing")) {
                    Picker(selection: $itemsGroupingKey, label: Text("Sort Items By")) {
                        ForEach(DatedItemGroup.GroupingKey.allCases, id: \.self) {
                            Text(LocalizedStringKey($0.rawValue))
                        }
                        // TODO: Picker 내부도 InsetGroupedListStyle()로 바꾸기
                        // 현재 iOS 14 베타에서는 작동하지 않는다.
                    }
                    Toggle("Use Reader When Available", isOn: $useReaderWhenAvailable)
                }
                Section {
                    Button(action: rootModel.clearCache) {
                        Text("Clear Cache")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Section {
                    Button(action: rootModel.removeAccessTokenContent) {
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
