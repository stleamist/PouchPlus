import SwiftUI

extension View {
    func alert<ErrorItem: Error>(error errorItem: Binding<ErrorItem?>) -> some View where ErrorItem: Identifiable {
        self.alert(item: errorItem) { error in
            if let localizedError = error as? LocalizedError {
                return Alert(title: Text(localizedError.errorDescription ?? "none"))
            } else {
                return Alert(title: Text(error.localizedDescription))
            }
        }
    }
}
