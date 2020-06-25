import SwiftUI

@main
struct PouchPlusApp: App {
    
    @StateObject private var rootModel = RootModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(rootModel)
        }
    }
}
