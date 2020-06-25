import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var rootModel: RootModel
    
    var body: some View {
        Group {
            if let accessTokenResponse = rootModel.accessTokenResponse {
                // StateObject에 들어갈 객체를 뷰 외부에서 초기화하는 것은 합법적이다!
                // 비록 외부 뷰에서는 새로운 객체를 생성할지 몰라도, 내부 뷰에서는 이를 무시하고 SwiftUI 스토리지에 저장된 객체를 가져다 쓴다.
                // https://www.donnywals.com/whats-the-difference-between-stateobject-and-observedobject/ 아래에서 3번째 문단 참조:
                // “However, this does not mean that you should mark all of your @ObservedObject properties as @StateObject.
                // In this last case, it might be the intent of the ItemList to create a fresh DataSource every time the view is redrawn.
                // If you'd have marked Counter.dataSource as @StateObject the new instance would be ignored and your app might now have a new hidden bug.”
                PouchView(pouchModel: PouchModel(accessTokenResponse: accessTokenResponse))
            } else {
                AuthenticationView(authenticationModel: AuthenticationModel())
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
