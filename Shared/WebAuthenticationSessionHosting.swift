import SwiftUI
import SafariServices
import AuthenticationServices

struct WebAuthenticationSession {
    
    let url: URL
    let callbackURLScheme: String?
    let completionHandler: ASWebAuthenticationSession.CompletionHandler
    
    var prefersEphemeralWebBrowserSession: Bool = true
}

class WebAuthenticationSessionViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    // MARK: ASWebAuthenticationPresentationContextProviding
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}

struct WebAuthenticationSessionHosting<Item: Identifiable>: UIViewControllerRepresentable {
    
    @Binding var item: Item?
    var onDismiss: (() -> Void)? = nil
    var sessionBuilder: (Item) -> WebAuthenticationSession
    
    func makeUIViewController(context: Context) -> WebAuthenticationSessionViewController {
        WebAuthenticationSessionViewController()
    }
    
    func updateUIViewController(_ uiViewController: WebAuthenticationSessionViewController, context: Context) {
        
        // SFAuthenticationViewController의 프레젠테이션 컨트롤러 델리게이트 지정을 위해
        // 뷰가 업데이트될 때마다 뷰가 띄우고 있는 뷰 컨트롤러를 확인한다.
        // SFAuthenticationViewController는 SFSafariViewController의 비공개 서브클래스이다.
        if let safariViewController = uiViewController.presentedViewController as? SFSafariViewController {
            safariViewController.presentationController?.delegate = context.coordinator
        }
        
        if let item = self.item {
            // Coordinator의 currentSession이 nil이 아닐 경우 중복 실행된 것이므로 함수를 탈출한다.
            guard context.coordinator.currentSession == nil else { return }
            
            // 완료 핸들러에 item을 nil로 설정하고 currentSession을 nil로 설정하는 코드를 주입하기 위해 커스텀 구조체 WebAuthenticationSession을 사용한다.
            // (ASWebAuthenticationSession 인스턴스는 퍼블릭 게터 / 세터가 없다.)
            let sessionData = sessionBuilder(item)
            let session = ASWebAuthenticationSession(url: sessionData.url, callbackURLScheme: sessionData.callbackURLScheme) { (callbackURL, error) in
                sessionData.completionHandler(callbackURL, error)
                self.item = nil
                context.coordinator.currentSession = nil
            }
            session.prefersEphemeralWebBrowserSession = sessionData.prefersEphemeralWebBrowserSession
            
            // ASWebAuthenticationSession 시작에 필수적인 presentationContextProvider를 지정한다.
            // ASWebAuthenticationPresentationContextProviding는 SFAuthenticationViewController를 띄울 윈도우를 반환하며,
            // 일반적으로 해당 윈도우의 루트 뷰 컨트롤러에서 present(_:animated:completion:)을 호출해 SFAuthenticationViewController를 띄운다.
            session.presentationContextProvider = uiViewController
            
            context.coordinator.currentSession = session
            session.start()
        } else {
            context.coordinator.currentSession?.cancel()
            context.coordinator.currentSession = nil
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        
        var parent: WebAuthenticationSessionHosting
        var currentSession: ASWebAuthenticationSession?
        
        init(_ parent: WebAuthenticationSessionHosting) {
            self.parent = parent
        }
        
        // MARK: UIAdaptivePresentationControllerDelegate
        
        // 시트를 풀 다운으로 내렸을 때 완료 핸들러가 실행되지 않아 item이 nil로 초기화되지 않는 문제가 있다.
        // SFAuthenticationViewController의 프레젠테이션 컨트롤러 델리게이트로 Coordinator를 설정하고,
        // 뷰 컨트롤러가 dismiss되었을 때 item을 nil로 설정하도록 한다.
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.item = nil
            currentSession?.cancel()
            currentSession = nil
            parent.onDismiss?()
        }
    }
}

extension Bool: Identifiable {
    public var id: Bool { self }
}

extension View {
    
    func webAuthenticationSession(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, sessionBuilder: @escaping () -> WebAuthenticationSession) -> some View {
        return self.background(
            WebAuthenticationSessionHosting(
                item: Binding<Bool?>(
                    get: { isPresented.wrappedValue ? true : nil },
                    set: { isPresented.wrappedValue = ($0 != nil) }
                ),
                onDismiss: onDismiss,
                sessionBuilder: { _ in
                    return sessionBuilder()
                }
            )
        )
    }
    
    func webAuthenticationSession<Item: Identifiable>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, sessionBuilder: @escaping (Item) -> WebAuthenticationSession) -> some View {
        return self.background(WebAuthenticationSessionHosting(item: item, onDismiss: onDismiss, sessionBuilder: sessionBuilder))
    }
}
