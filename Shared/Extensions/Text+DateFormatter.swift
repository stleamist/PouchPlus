import SwiftUI

extension Text {
    init(_ date: Date?, formatter: DateFormatter) {
        if let date = date {
            self.init(formatter.string(from: date))
        } else {
            self.init("Unknown")
        }
    }
}
