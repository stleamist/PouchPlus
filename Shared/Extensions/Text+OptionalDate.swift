import SwiftUI

extension Text {
    init(_ date: Date?, style: Text.DateStyle) {
        if let date = date {
            self.init(date, style: style)
        } else {
            self.init("Unknown")
        }
    }
}
