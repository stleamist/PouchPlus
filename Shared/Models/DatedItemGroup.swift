import Foundation

extension Date {
    var timeComponentsRemoved: Self {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        guard let date = Calendar.current.date(from: dateComponents) else {
            assertionFailure("Failed to remove time components from the Date.")
            return Date(timeIntervalSince1970: 0)
        }
        return date
    }
}

struct DatedItemGroup {
    let date: Date?
    let items: [PocketService.Item]
    
    static func groups(from items: [String: PocketService.Item]) -> [Self] {
        let groupedDictionary = Dictionary(grouping: items.values) { item -> Date? in
            // TODO: timeAdded, timeUpdated 중 선택할 수 있도록 하기
            guard let timeInterval = Double(item.timeAdded) else {
                return nil
            }
            let date = Date(timeIntervalSince1970: timeInterval).timeComponentsRemoved
            return date
        }
        let groups = groupedDictionary.map { Self(date: $0, items: $1) }
            .sorted { lhs, rhs in
                // TODO: 오름차순, 내림차순 중 선택할 수 있도록 하기
                lhs.date?.timeIntervalSince1970 ?? -.infinity > rhs.date?.timeIntervalSince1970 ?? -.infinity
            }
        return groups
    }
}

extension DatedItemGroup: Identifiable {
    var id: Date? { date }
}
