import Combine
import Alamofire

class PouchPlusModel: ObservableObject {
    
    // 에러 핸들링을 위해 String이 아닌 DataResponse를 퍼블리싱한다.
    @Published private(set) var requestTokenResponse: DataResponse<String, AFError>?
    
    // ProgressView를 위한 source of truth이다.
    @Published private(set) var requestTokenRequestIsInProgress = false
    
    // request token을 동시애 여러 번 요청할 수 없도록 단일 AnyCancellable을 보관하고,
    // 새로운 요청이 들어올 경우 이전 요청을 취소하도록 한다.
    private var requestTokenRequestCancellable: AnyCancellable?
}

extension PouchPlusModel {
    func loadRequestToken(redirectURI: String) {
        
        requestTokenRequestIsInProgress = true
        
        requestTokenRequestCancellable?.cancel()
        
        requestTokenRequestCancellable = PocketService.shared
            .requestTokenPublisher(redirectURI: redirectURI)
            .sink { response in
                self.requestTokenResponse = response
                self.requestTokenRequestIsInProgress = false
            }
    }
    
    // requestTokenResponse의 requestToken과 error 값을 뷰 프레젠테이션의 Binding으로 사용하기 위해 필요한 액션이다.
    func removeRequestTokenResponse() {
        self.requestTokenResponse = nil
    }
}
