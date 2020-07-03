import SwiftUI

struct ItemEditView: View {
    
    @EnvironmentObject var pouchModel: PouchModel
    
    @Environment(\.presentationMode) var presentationMode
    
    enum Mode {
        case add
        case edit
    }
    
    var mode: Mode
    
    @State private var urlString: String = ""
    @State private var title: String = ""
    @State private var tags: String = ""
    
    private var url: URL? { URL.percentEncoded(string: urlString) }
    private var urlIsInvalid: Bool { url == nil }
    
    var body: some View {
        return NavigationView {
            Form {
                Section {
                    HStack {
                        Text("URL")
                        TextField("Required", text: $urlString)
                            .textContentType(.URL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    HStack {
                        Text("Title")
                        TextField("Optional", text: $title)
                    }
                    HStack {
                        Text("Tags")
                        TextField("Optional", text: $tags)
                            .autocapitalization(.none)
                    }
                }
            }
            .navigationBarTitle("Add Item", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: dismiss) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: addItem) {
                        Text("Done")
                    }
                    .disabled(urlIsInvalid)
                }
            }
        }
    }
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func addItem() {
        guard let url = self.url else { return }
        let title = (!self.title.isEmpty) ? self.title : nil
        let tags = (!self.tags.isEmpty) ? self.tags : nil
        let query = PocketService.AdditionQuery(url: url, title: title, tags: tags)
        pouchModel.addItem(query: query)
        dismiss()
    }
}

struct ItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ItemEditView(mode: .add)
    }
}
