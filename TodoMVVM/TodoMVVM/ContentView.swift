import SwiftUI

/// Composition root for the screen.
///
/// It *owns* the ViewModel using `@StateObject` (so the instance survives view
/// re-renders) and injects it into `TodoListView`. This mirrors the
/// "ContentView hosts the feature view" structure from the lecture material,
/// while using `@StateObject` for correct ownership semantics.
struct ContentView: View {
    @StateObject private var viewModel = ContentView.makeViewModel()

    var body: some View {
        TodoListView(viewModel: viewModel)
    }

    /// Builds the ViewModel for the app. By default it starts empty; when the
    /// `SCREENSHOT_STATE` launch environment variable is present the screen is
    /// seeded with a known state so documentation screenshots are reproducible.
    /// Normal app runs never set this variable, so production behaviour is the
    /// default empty state.
    private static func makeViewModel() -> TodoListViewModel {
        switch ProcessInfo.processInfo.environment["SCREENSHOT_STATE"] {
        case "loaded":
            return TodoListViewModel(todos: [
                Todo(title: "Todo #1"),
                Todo(title: "Todo #2", isCompleted: true),
                Todo(title: "Todo #3"),
                Todo(title: "Todo #4")
            ])
        case "error":
            return TodoListViewModel(newTodoTitle: "ab",
                                     errorMessage: "Todo must be longer than 2 characters")
        default:
            return TodoListViewModel()
        }
    }
}

#Preview {
    ContentView()
}
