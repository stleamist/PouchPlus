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
                Section(header: Text("Viewing")) {
                    Picker(selection: $itemsGroupingKey, label: Text("Sort Items By")) {
                        ForEach(DatedItemGroup.GroupingKey.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                        // TODO: Picker 내부도 InsetGroupedListStyle()로 바꾸기
                        // 현재 iOS 14 베타에서는 작동하지 않는다.
                    }
                    Toggle("Enters Reader If Available", isOn: $entersReaderIfAvailable)
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
