import SwiftUI

@main
struct PouchPlusApp: App {
    
    @StateObject private var authenticationModel = AuthenticationModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authenticationModel)
        }
    }
}
