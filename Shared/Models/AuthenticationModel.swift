import Combine
import Alamofire

class AuthenticationModel: ObservableObject {
    
    // MARK: Request Token
    
    // 에러 핸들링을 위해 String이 아닌 DataResponse를 퍼블리싱한다.
    @Published private(set) var requestTokenResult: Result<String, PouchPlusError>?
    
    // ProgressView를 위한 source of truth이다.
    @Published private(set) var requestTokenRequestIsInProgress = false
    
    // MARK: Access Token
    
    @Published private(set) var accessTokenContentResult: Result<PocketService.AccessTokenContent, PouchPlusError>?
    
    // MARK: Cancellables
    private var cancellables = Set<AnyCancellable>()
}

extension AuthenticationModel {
    
    func loadRequestToken(redirectURI: String) {
        PocketService.shared
            .requestTokenPublisher(query: .init(redirectUri: redirectURI))
            .map { $0.map(\.requestToken) }
            .map { $0.mapError({ .commonError(.networkError($0)) }) }
            .handleEvents(
                receiveCompletion: { _ in self.requestTokenRequestIsInProgress = false },
                receiveRequest: { _ in self.requestTokenRequestIsInProgress = true }
            )
            .assign(to: \.requestTokenResult, on: self)
            .store(in: &cancellables)
    }
    
    func loadAccessToken(requestToken: String) {
        PocketService.shared
            .accessTokenPublisher(query: .init(requestToken: requestToken))
            .map { $0.mapError({ .commonError(.networkError($0)) }) }
            .assign(to: \.accessTokenContentResult, on: self)
            .store(in: &cancellables)
    }
}
