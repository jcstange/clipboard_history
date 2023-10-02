import Foundation
import Cocoa

class ClipboardViewModel: ObservableObject {
    @Published var clipboard: [Clipboard] = []
    @Published var filteredClipboard: [Clipboard] = []
    var timer: Timer?
    
    init() {}
    
    init(clipboard: [Clipboard]) {
        self.clipboard = clipboard
    }
    
    var previousClipboardContents = NSPasteboard.general.string(forType: .string) ?? ""
    
    func checkClipboardForChanges() {
        let currentClipboardContents = NSPasteboard.general.string(forType: .string) ?? ""
        
        if currentClipboardContents != previousClipboardContents {
            // Clipboard contents have changed
            print("Clipboard updated: \(currentClipboardContents)")
            clipboard.append(Clipboard(date: dateFormatter.string(from: Date()), string: currentClipboardContents))
            filteredClipboard = clipboard
            previousClipboardContents = currentClipboardContents
        }
    }
    
    func filterClipboardHistory(filter: String) {
        if filter == "" {
            filteredClipboard = clipboard
        } else {
            filteredClipboard = clipboard.filter { item in
                item.string.contains(filter)
            }
        }
    }
    
    // Poll for clipboard changes every second
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.checkClipboardForChanges()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust this format to match your clipboard content format
        return formatter
    }()
}
