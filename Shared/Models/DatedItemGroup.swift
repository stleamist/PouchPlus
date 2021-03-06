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
    
    static func groupItems(items: [String: PocketService.Item], by key: GroupingKey) -> [Self] {
        let groupedDictionary = Dictionary(grouping: items.values) { item -> Date? in
            let timeString = item[keyPath: key.keyPathForItem]
            guard let timeInterval = Double(timeString) else {
                return nil
            }
            let date = Date(timeIntervalSince1970: timeInterval).timeComponentsRemoved
            return date
        }
        let groups = groupedDictionary
            .map { date, items in
                // FIXME: Item 응답 디코딩 시 미리 시간 값을 Date로 변환하여 보일러플레이트 코드 줄이기
                Self(
                    date: date,
                    items: items.sorted { lhs, rhs in
                        let lhsTimeInterval = Double(lhs[keyPath: key.keyPathForItem]) ?? -.infinity
                        let rhsTimeInterval = Double(rhs[keyPath: key.keyPathForItem]) ?? -.infinity
                        return Date(timeIntervalSince1970: lhsTimeInterval) > Date(timeIntervalSince1970: rhsTimeInterval)
                    }
                )
            }
            .sorted { lhs, rhs in
                let defaultValue = Date(timeIntervalSince1970: -.infinity)
                return lhs.date ?? defaultValue > rhs.date ?? defaultValue
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
