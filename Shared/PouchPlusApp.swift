import SwiftUI

@main
struct PouchPlusApp: App {
    
    @StateObject private var model = PouchPlusModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
