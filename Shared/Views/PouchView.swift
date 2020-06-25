import SwiftUI

struct PouchView: View {
    
    @EnvironmentObject private var rootModel: RootModel
    @StateObject var pouchModel: PouchModel
    
    var body: some View {
        Text("Hello, World!")
    }
}

//struct PouchView_Previews: PreviewProvider {
//    static var previews: some View {
//        PouchView()
//    }
//}
