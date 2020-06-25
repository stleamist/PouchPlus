import Combine
import Alamofire

class PouchPlusModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Request Token
    
    // 에러 핸들링을 위해 String이 아닌 DataResponse를 퍼블리싱한다.
    @Published private(set) var requestTokenResult: Result<String, PouchPlusError>?
    
    // ProgressView를 위한 source of truth이다.
    @Published private(set) var requestTokenRequestIsInProgress = false
    
    // request token을 동시애 여러 번 요청할 수 없도록 단일 AnyCancellable을 보관하고,
    // 새로운 요청이 들어올 경우 이전 요청을 취소하도록 한다.
    private var requestTokenRequestCancellable: AnyCancellable?
    
    // MARK: Access Token
    
    @Published private(set) var accessTokenResult: Result<String, PouchPlusError>?
}

extension PouchPlusModel {
    
    func loadRequestToken(redirectURI: String) {
        
        requestTokenRequestCancellable?.cancel()
        
        requestTokenRequestCancellable = PocketService.shared
            .requestTokenPublisher(redirectURI: redirectURI)
            .map { result in result.mapError { afError in .commonError(.networkError(afError)) } }
            .handleEvents(
                receiveCompletion: { _ in self.requestTokenRequestIsInProgress = false },
                receiveRequest: { _ in self.requestTokenRequestIsInProgress = true }
            )
            .assign(to: \.requestTokenResult, on: self)
    }
    
    func loadAccessToken() {
        guard let requestToken = try? requestTokenResult?.get() else {
            assertionFailure("The app attempted to load an access token before a request token is set. That's illegal.")
            accessTokenResult = .failure(.developerError(.requestTokenNotSet))
            return
        }
        PocketService.shared
            .accessTokenPublisher(requestToken: requestToken)
            .map { result in result.mapError { afError in .commonError(.networkError(afError)) } }
            .assign(to: \.accessTokenResult, on: self)
            .store(in: &cancellables)
    }
}
