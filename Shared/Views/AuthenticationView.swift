import SwiftUI
import Combine
import AuthenticationServices
import Alamofire
import ExtensionKit
import FullScreenSafariView

// Identifiable protocol conformances for webAuthenticationSession item binding
// TODO: 분리된 파일로 옮기기

extension String: Identifiable {
    public var id: String { self }
}

extension PouchPlusError: Identifiable {
    var id: UUID { UUID() }
}

struct AuthenticationView: View {
    
    @EnvironmentObject private var rootModel: RootModel
    @StateObject var authenticationModel: AuthenticationModel
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    enum Mode: String {
        case logIn
        case signUp
    }
    
    @State private var mode: Mode?
    
    // TODO: 모델에서 유래된 @State들을 모델로 옮기기
    
    @State private var requestToken: String?
    
    @State private var requestTokenError: PouchPlusError?
    @State private var authorizationError: PouchPlusError?
    @State private var accessTokenError: PouchPlusError?
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Pouch+")
                .font(.system(size: 32, weight: .bold))
            
            Spacer()
            
            HStack(spacing: 16) {
                Group {
                    actionButton(for: .logIn, colorLevel: .secondary) {
                        Text("Log In")
                    }
                    actionButton(for: .signUp, colorLevel: .primary) {
                        Text("Sign Up")
                    }
                }
                .frame(height: 54)
                .font(.system(size: 20, weight: .semibold))
                .cornerRadius(12)
            }
        }
        .padding(16)
        .onReceive(authenticationModel.$requestTokenResult) { result in
            switch result {
            case .success(let requestToken):
                self.requestToken = requestToken
            case .failure(let error):
                self.requestTokenError = error
            case .none: ()
                self.requestToken = nil
                self.requestTokenError = nil
            }
        }
        .webAuthenticationSession(item: $requestToken) { requestToken in
            let url = URL(string: "https://getpocket.com/auth/authorize")!
                .withQueryStrings([
                    "request_token": requestToken,
                    "redirect_uri": Constant.redirectURI,
                    "force": mode?.rawValue.lowercased()
                ])
            return WebAuthenticationSession(url: url, callbackURLScheme: Constant.urlScheme) { callbackURL, error in
                if let error = error, (error as? ASWebAuthenticationSessionError)?.code != .canceledLogin {
                    self.authorizationError = .commonError(.webAuthenticationSessionError(error))
                    return
                }
                guard callbackURL?.absoluteString == Constant.redirectURI else {
                    return
                }
                authenticationModel.loadAccessToken(requestToken: requestToken)
            }
            .prefersEphemeralWebBrowserSession(mode == .signUp)
        }
        .onReceive(authenticationModel.$accessTokenContentResult) { result in
            switch result {
            case .success(let accessTokenContent):
                self.rootModel.setAccessTokenContent(accessTokenContent)
            case .failure(let error):
                self.accessTokenError = error
            case .none:
                ()
            }
        }
        .background(Group {
            // SwiftUI에서는 하나의 뷰의 여러 알림을 붙이면 충돌이 발생한다.
            // 이를 해결하기 위해, 세 개의 투명 뷰를 만들어 각자의 알림을 붙인다.
            // (EmptyView에서는 똑같이 충돌이 발생하기에 Color 뷰를 사용했다.)
            // 참고: https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-multiple-alerts-in-a-single-view
            Color.clear
                .alert(error: $requestTokenError)
            Color.clear
                .alert(error: $authorizationError)
            Color.clear
                .alert(error: $accessTokenError)
        })
    }
    
    private func actionButton<Label: View>(for mode: Mode, colorLevel: FilledButtonStyle.Level, @ViewBuilder label: () -> Label) -> some View {
        let progressViewTintColor: Color = (colorLevel == .primary) ? .white : .accentColor
        
        return Button(action: {
            self.mode = mode
            // 버튼을 연달아 눌렀을 때 요청을 여러 번 전송하는 것을 막는다.
            guard !self.authenticationModel.requestTokenRequestIsInProgress else {
                return
            }
            self.authenticationModel.loadRequestToken(redirectURI: Constant.redirectURI)
        }) {
            HStack(spacing: 8) {
                Spacer()
                    .overlay(Group {
                        if authenticationModel.requestTokenRequestIsInProgress && self.mode == mode {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: progressViewTintColor)
                                )
                        }
                    }, alignment: .trailing)
                label()
                Spacer()
            }
        }
        .buttonStyle(FilledButtonStyle(colorScheme: colorScheme, level: colorLevel))
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(authenticationModel: AuthenticationModel())
    }
}
