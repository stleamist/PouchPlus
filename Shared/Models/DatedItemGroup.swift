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

enum Order: Int {
    case ascending
    case descending
    
    func areInIncreasingOrder<T: Comparable>(lhs: T, rhs: T) -> Bool {
        switch self {
        case .ascending: return lhs <= rhs
        case .descending: return lhs >= rhs
        }
    }
    
    func areInIncreasingOrder<T: Comparable>(lhs: T?, rhs: T?, defaultValue: T) -> Bool {
        switch self {
        case .ascending: return lhs ?? defaultValue <= rhs ?? defaultValue
        case .descending: return lhs ?? defaultValue >= rhs ?? defaultValue
        }
    }
}

struct DatedItemGroup {
    let date: Date?
    let items: [PocketService.Item]
    
    static func groupItems(items: [String: PocketService.Item], by key: GroupingKey, sorting order: Order) -> [Self] {
        let groupedDictionary = Dictionary(grouping: items.values) { item -> Date? in
            let timeString = item[keyPath: key.keyPathForItem]
            guard let timeInterval = Double(timeString) else {
                return nil
            }
            let date = Date(timeIntervalSince1970: timeInterval).timeComponentsRemoved
            return date
        }
        let groups = groupedDictionary.map { Self(date: $0, items: $1) }
            .sorted { lhs, rhs in
                order.areInIncreasingOrder(lhs: lhs.date, rhs: rhs.date, defaultValue: Date(timeIntervalSince1970: -.infinity)
                )
            }
        return groups
    }
}

extension DatedItemGroup {
    enum GroupingKey: String, CaseIterable {
        case timeAdded
        case timeUpdated
        
        var keyPathForItem: KeyPath<PocketService.Item, String> {
            switch self {
            case .timeAdded: return \.timeAdded
            case .timeUpdated: return \.timeUpdated
            }
        }
    }
}

extension DatedItemGroup: Identifiable {
    var id: Date? { date }
}
