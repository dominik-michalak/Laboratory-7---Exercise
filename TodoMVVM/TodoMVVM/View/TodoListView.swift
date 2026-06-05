import SwiftUI

/// The **View** layer: it only describes *how* the state looks and forwards
/// user actions to the ViewModel. It contains no business logic, no validation
/// and no data loading - all of that now lives in `TodoListViewModel`.
///
/// The view observes the ViewModel through `@ObservedObject`; whenever a
/// `@Published` property changes, SwiftUI re-renders the affected parts.
struct TodoListView: View {
    @ObservedObject var viewModel: TodoListViewModel

    var body: some View {
        VStack {
            Text("My Todos")
                .font(.largeTitle)

            if viewModel.isLoading {
                ProgressView()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            HStack {
                TextField("New todo", text: $viewModel.newTodoTitle)

                Button("Add") {
                    viewModel.addTodo()
                }
            }
            .padding()

            List {
                ForEach(viewModel.activeTodos) { todo in
                    TodoRow(todo: todo) {
                        viewModel.markDone(todo)
                    }
                }
            }

            Button("Load Sample Todos") {
                viewModel.loadSampleTodos()
            }

            Text("Completed: \(viewModel.completedCount)")
                .padding()
        }
        .padding()
    }
}

#Preview {
    TodoListView(viewModel: TodoListViewModel())
}
