import SwiftUI

@main
struct PouchPlusApp: App {
    
    @StateObject private var model = PocketPlusModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
