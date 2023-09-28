import SwiftUI

@main
struct Clipboard_HistoryApp: App {
    var body: some Scene {
        WindowGroup {
            ClipboardView(viewModel: ClipboardViewModel())
        }
    }
}
