import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var rootModel: RootModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ValueLabel(title: "Username", value: rootModel.accessTokenResponse?.username ?? "")
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
