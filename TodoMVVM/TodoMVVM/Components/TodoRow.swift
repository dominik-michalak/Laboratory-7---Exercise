import SwiftUI

/// A small, reusable piece of the View layer rendering a single todo row.
///
/// It is "dumb": it receives the data to display and a closure to call when the
/// user taps *Done*. It owns no state and knows nothing about the ViewModel,
/// which keeps it easy to preview and reuse.
struct TodoRow: View {
    let todo: Todo
    let onDone: () -> Void

    var body: some View {
        HStack {
            Text(todo.title)

            Spacer()

            Button("Done", action: onDone)
                .buttonStyle(.borderless)
        }
    }
}

#Preview {
    List {
        TodoRow(todo: Todo(title: "Buy milk"), onDone: {})
        TodoRow(todo: Todo(title: "Walk the dog"), onDone: {})
    }
}
