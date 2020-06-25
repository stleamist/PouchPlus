import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var appModel: AppModel
    @StateObject var mainModel: MainModel
    
    var body: some View {
        Text("Hello, World!")
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
