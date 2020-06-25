import SwiftUI
import Combine
import Alamofire
import ExtensionKit

// Identifiable protocol conformances for webAuthenticationSession item binding

extension String: Identifiable {
    public var id: String { self }
}

extension AFError: Identifiable {
    public var id: UUID { UUID() }
}


struct LogInView: View {
    
    enum Mode: String {
        case logIn
        case signUp
    }
    
    @EnvironmentObject private var model: PouchPlusModel
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var mode: Mode?
    
    private var requestTokenBinding: Binding<String?> {
        return Binding {
            return try? model.requestTokenResponse?.result.get()
        } set: {
            guard $0 == nil else { return }
            model.removeRequestTokenResponse()
        }
    }
    
    private var errorBinding: Binding<AFError?> {
        return Binding {
            guard case .failure(let error) = model.requestTokenResponse?.result else {
                return nil
            }
            return error
        } set: {
            guard $0 == nil else { return }
            model.removeRequestTokenResponse()
        }
    }
    
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
        .webAuthenticationSession(item: requestTokenBinding) { requestToken in
            let url = URL(string: "https://getpocket.com/auth/authorize")!
                .withQueryStrings([
                    "request_token": requestToken,
                    "redirect_uri": Constant.redirectURI,
                    "force": mode?.rawValue.lowercased()
                ])
            return WebAuthenticationSession(url: url, callbackURLScheme: Constant.urlScheme) { callbackURL, error in
                print(callbackURL, error)
            }
        }
        .alert(item: errorBinding) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }
    
    private func actionButton<Label: View>(for mode: Mode, colorLevel: FilledButtonStyle.Level, @ViewBuilder label: () -> Label) -> some View {
        let progressViewTintColor: Color = (colorLevel == .primary) ? .white : .accentColor
        
        return Button(action: {
            self.mode = mode
            self.model.loadRequestToken(redirectURI: Constant.redirectURI)
        }) {
            HStack(spacing: 8) {
                Spacer()
                    .overlay(Group {
                        if model.requestTokenRequestIsInProgress && self.mode == mode {
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

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
