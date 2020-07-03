import Combine
import Alamofire

class PouchModel: ObservableObject {
    
    @Published var latestRetrievalResult: Result<PocketService.RetrievalContent, PouchPlusError>? = nil
    @Published var latestAdditionResult: Result<PocketService.AdditionContent, PouchPlusError>? = nil
    @Published var items: [String: PocketService.Item] = [:]
    
    // MARK: Access Token
    private let accessTokenContent: PocketService.AccessTokenContent
    private var accessToken: String { accessTokenContent.accessToken }
    
    // MARK: Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    init(accessTokenContent: PocketService.AccessTokenContent) {
        self.accessTokenContent = accessTokenContent
        subscribeProperties()
    }
    
    // MARK: Property Subscriptions
    
    private func subscribeProperties() {
        self.$latestRetrievalResult
            .compactMap { try? $0?.get().list }
            .sink { self.appendItems($0) }
            .store(in: &cancellables)
    }
    
    // MARK: Actions
    
    private func appendItems(_ items: [String: PocketService.Item]) {
        // FIXME: 단순한 merge 대신 새로운 항목 중 가장 오래된 항목의 시간을 기점으로 그 이후 기존의 항목을 제거한 다음 합치기
        self.items.merge(items) { (_, new) in new }
    }
}

extension PouchModel {
    // FIXME: 다듬기
    func retrieveItems(query: PocketService.RetrievalQuery) {
        PocketService.shared
            .retrievalPublisher(accessToken: accessToken, query: query)
            .map { $0.mapError({ PouchPlusError.commonError(.networkError($0)) }) }
            .assign(to: \.latestRetrievalResult, on: self)
            .store(in: &cancellables)
    }
    
    func addItem(query: PocketService.AdditionQuery) {
        PocketService.shared
            .additionPublisher(accessToken: accessToken, query: query)
            .map { $0.mapError({ PouchPlusError.commonError(.networkError($0)) }) }
            .assign(to: \.latestAdditionResult, on: self)
            .store(in: &cancellables)
    }
}
