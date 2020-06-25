import SwiftUI

struct ValueLabel: View {
    
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(Color(.label))
            Spacer()
            Text(value)
                .foregroundColor(Color(.secondaryLabel))
        }
    }
}
