import SwiftUI

@main
struct PouchPlusApp: App {
    
    @StateObject var rootModel = RootModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(rootModel)
        }
    }
}
