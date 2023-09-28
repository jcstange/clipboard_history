import Foundation

struct Clipboard: Identifiable, Hashable {
    let id = UUID()
    var date: String
    var string: String
}
