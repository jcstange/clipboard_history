import SwiftUI

struct ClipboardView: View {
    @ObservedObject var viewModel: ClipboardViewModel
    @State private var search: String = ""
    @Environment(\.scenePhase) private var scenePhase
    
    init(viewModel: ClipboardViewModel) {
        self.viewModel = viewModel
    }

    
    var body: some View {
        VStack(alignment: .leading) {
            ClearableTextField(text: $search)
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
            }.frame(height: 500)
            GeometryReader { geometry in
                            Button(action: {
                if scenePhase == .background {
                    NSApplication.shared.terminate(self) // This quits the app.
                }
            }) {
                Text("Quit")
                    .frame(width: geometry.size.width, alignment: .center).padding(5) // Adjust as needed
                }
            }
        }
    }

}

struct ClearableTextField: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

struct ClipboardView_Previews: PreviewProvider {
    static var previews: some View {
        ClipboardView(viewModel: ClipboardViewModel())
    }
}
