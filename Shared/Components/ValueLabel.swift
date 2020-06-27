import SwiftUI

struct ValueLabel: View {
    
    let title: Text
    let value: Text
    
    var body: some View {
        HStack {
            title
                .foregroundColor(Color(.label))
            Spacer()
            value
                .foregroundColor(Color(.secondaryLabel))
        }
    }
}
