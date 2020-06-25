import SwiftUI

struct PouchView: View {
    
    @EnvironmentObject private var rootModel: RootModel
    @StateObject var pouchModel: PouchModel
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct PouchView_Previews: PreviewProvider {
    
    static let sampleAccessTokenContent = PocketService.AccessTokenContent(accessToken: "5678defg-5678-defg-5678-defg56", username: "pocketuser")
    @StateObject static var pouchModel = PouchModel(accessTokenContent: sampleAccessTokenContent)
    
    static var previews: some View {
        PouchView(pouchModel: pouchModel)
    }
}
