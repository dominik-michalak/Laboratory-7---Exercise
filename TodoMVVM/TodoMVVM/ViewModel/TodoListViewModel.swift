import Foundation

/// Presentation logic for the to-do screen.
///
/// In MVVM the **ViewModel** is the intermediary between the Model and the
/// View. It owns the screen's state (`@Published` properties), exposes data in
/// a form ready for display, and handles the user intents forwarded by the
/// View. Crucially it imports only `Foundation` - it never imports `SwiftUI`,
/// so it stays decoupled from the UI and can be unit-tested in isolation.
@MainActor
final class TodoListViewModel: ObservableObject {

    // MARK: - Published state (the View observes these)

    /// The single source of truth: every todo, completed or not.
    @Published private(set) var todos: [Todo] = []
    /// Two-way bound to the text field in the View.
    @Published var newTodoTitle: String = ""
    /// Drives the progress indicator while sample data is "loading".
    @Published private(set) var isLoading = false
    /// Validation / loading feedback shown to the user.
    @Published var errorMessage: String?

    // MARK: - Init

    /// The running app uses `TodoListViewModel()` and starts empty. The same
    /// initializer lets SwiftUI previews and screenshot builds start from a
    /// known state by passing seed values. Notice the View never changes - only
    /// the state injected into the ViewModel does. That is exactly the
    /// decoupling MVVM gives us.
    init(todos: [Todo] = [], newTodoTitle: String = "", errorMessage: String? = nil) {
        self.todos = todos
        self.newTodoTitle = newTodoTitle
        self.errorMessage = errorMessage
    }

    // MARK: - Derived data (computed, so it can never get out of sync)

    /// Todos still to be done - this is what the list displays.
    var activeTodos: [Todo] {
        todos.filter { !$0.isCompleted }
    }

    /// How many todos have been completed.
    var completedCount: Int {
        todos.filter(\.isCompleted).count
    }

    // MARK: - User intents (called by the View)

    /// Adds `newTodoTitle` as a new todo if it passes model validation.
    func addTodo() {
        let title = newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard Todo.isValid(title: title) else {
            errorMessage = "Todo must be longer than 2 characters"
            return
        }

        todos.append(Todo(title: title))
        newTodoTitle = ""
        errorMessage = nil
    }

    /// Marks the given todo as completed. It then drops out of `activeTodos`
    /// and is reflected in `completedCount`.
    func markDone(_ todo: Todo) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[index].isCompleted = true
    }

    /// Simulates an asynchronous fetch of sample todos (mirrors the original
    /// `DispatchQueue.main.asyncAfter` demo, but expressed with structured
    /// concurrency). Because the class is `@MainActor`, the state mutations
    /// below are guaranteed to run on the main thread.
    func loadSampleTodos() {
        isLoading = true

        Task {
            try? await Task.sleep(for: .seconds(2))
            todos = [
                Todo(title: "Todo #1"),
                Todo(title: "Todo #2"),
                Todo(title: "Todo #3"),
                Todo(title: "Todo #4")
            ]
            isLoading = false
        }
    }
}
