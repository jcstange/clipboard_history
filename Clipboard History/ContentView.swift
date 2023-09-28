import SwiftUI

struct ClipboardView: View {
    @ObservedObject var viewModel: ClipboardViewModel
    @State private var search: String = ""
    
    init(viewModel: ClipboardViewModel) {
        self.viewModel = viewModel
    }

    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Search", text: $search)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            List(viewModel.filteredClipboard, id: \.self) { item in
                Section {
                    Text("\(item.date) : \(item.string)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                }
                .listStyle(.plain)
                .listRowBackground(
                    Color(hex: "#222222").cornerRadius(10)
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top:0, leading: 0, bottom: 10, trailing: 0))
                .padding()
                .frame(maxWidth: .infinity)
            }.onChange(of: search) { newSearch in
                viewModel.filterClipboardHistory(filter: newSearch)
            }
            .onAppear {
                viewModel.startTimer()
            }.onDisappear {
                viewModel.stopTimer()
            }}
    }

}

struct ClipboardView_Previews: PreviewProvider {
    static var previews: some View {
        ClipboardView(viewModel: ClipboardViewModel())
    }
}
