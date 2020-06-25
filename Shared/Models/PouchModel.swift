import Combine
import Alamofire

class PouchModel: ObservableObject {
    
    @Published var latestRetrievalResult: Result<PocketService.RetrievalContent, PouchPlusError>?
    @Published var items: [PocketService.Item] = []
    
    private let accessTokenContent: PocketService.AccessTokenContent
    
    private var accessToken: String {
        return accessTokenContent.accessToken
    }
    
    // MARK: Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    init(accessTokenContent: PocketService.AccessTokenContent) {
        self.accessTokenContent = accessTokenContent
    }
}

extension PouchModel {
    // FIXME: 다듬기
    func loadItems(query: PocketService.RetrievalQuery) {
        PocketService.shared
            .itemsPublisher(accessToken: accessToken, query: query)
            .map { $0.mapError({ PouchPlusError.commonError(.networkError($0)) }) }
            .sink { result in
                self.latestRetrievalResult = result
                guard let list = try? result.get().list else {
                    return
                }
                let items = list.values.map({ $0 }).sorted(by: { $0.sortId < $1.sortId })
                self.items.append(contentsOf: items)
            }
            .store(in: &cancellables)
    }
}
