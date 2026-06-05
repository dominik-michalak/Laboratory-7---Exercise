import Foundation

/// Domain model representing a single to-do item.
///
/// In MVVM the **Model** layer holds the application's data together with the
/// business rules that operate on that data. The model is deliberately free of
/// any SwiftUI / UIKit dependency - it has no idea how (or whether) it is
/// displayed on screen. This keeps it reusable and trivial to unit-test.
struct Todo: Identifiable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

extension Todo {
    /// A todo title has to be **longer than 2 characters** (the rule that was
    /// hard-coded inside the original view). Encoding it on the model keeps the
    /// rule in one place and reusable by any layer that needs it.
    static let minimumTitleLength = 3

    /// Validates a candidate title after trimming surrounding whitespace.
    static func isValid(title: String) -> Bool {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= minimumTitleLength
    }
}
