import SwiftUI

extension View {
    func alert<ErrorItem: Error>(error errorItem: Binding<ErrorItem?>) -> some View where ErrorItem: Identifiable {
        self.alert(item: errorItem) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }
}
