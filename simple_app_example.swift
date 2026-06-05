import SwiftUI

struct TodoView: View {
    @State private var todos: [String] = []
    @State private var newTodo: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var completedTodos: [String] = []

    var body: some View {
        VStack {
            Text("My Todos")
                .font(.largeTitle)

            if isLoading {
                ProgressView()
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            HStack {
                TextField("New todo", text: $newTodo)

                Button("Add") {
                    if newTodo.count > 2 {
                        todos.append(newTodo)
                        newTodo = ""
                    } else {
                        errorMessage = "Todo must be longer than 2 characters"
                    }
                }
            }
            .padding()

            List {
                ForEach(todos, id: \.self) { todo in
                    HStack {
                        Text(todo)

                        Spacer()

                        Button("Done") {
                            completedTodos.append(todo)

                            if let index = todos.firstIndex(of: todo) {
                                todos.remove(at: index)
                            }
                        }
                    }
                }
            }

            Button("Load Sample Todos") {
                isLoading = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    todos = [
                        "Todo #1",
                        "Todo #2",
                        "Todo #3",
                        "Todo #4"
                    ]
                    isLoading = false
                }
            }

            Text("Completed: \(completedTodos.count)")
                .padding()
        }
        .padding()
    }
}