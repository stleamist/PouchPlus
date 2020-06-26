import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var rootModel: RootModel
    
    @AppStorage(AppStorageKey.entersReaderIfAvailable.rawValue) var entersReaderIfAvailable: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ValueLabel(title: "Username", value: rootModel.accessTokenResponse?.username ?? "")
                }
                Section {
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
