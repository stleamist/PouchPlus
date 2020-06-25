import SwiftUI

struct PouchView: View {
    
    @EnvironmentObject private var rootModel: RootModel
    @StateObject var pouchModel: PouchModel
    
    var body: some View {
        TabView {
            ItemList()
                .tabItem {
                    Label("Items", systemImage: "heart.text.square.fill")
                        .imageScale(.large)
                }
            Color.clear
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                        .imageScale(.large)
                }
            Color.clear
                .tabItem {
                    Label("Archive", systemImage: "archivebox.fill")
                        .imageScale(.large)
                }
            Color.clear
                .tabItem {
                    Label("Tags", systemImage: "tag.fill")
                        .imageScale(.large)
                }
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                        .imageScale(.large)
                }
        }
        .environmentObject(pouchModel)
    }
}

struct PouchView_Previews: PreviewProvider {
    
    static let sampleAccessTokenContent = PocketService.AccessTokenContent(accessToken: "5678defg-5678-defg-5678-defg56", username: "pocketuser")
    @StateObject static var pouchModel = PouchModel(accessTokenContent: sampleAccessTokenContent)
    
    static var previews: some View {
        PouchView(pouchModel: pouchModel)
    }
}
