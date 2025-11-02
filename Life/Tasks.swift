//
//  Tasks.swift
//  Life
//
//  Created by David Fitzgerald on 30/10/2025.
//

import SwiftUI
import SwiftData


struct TaskListView: View {
    /**
     * View environment.
     */
    @Environment(\.modelContext) private var modelContext
    @Namespace private var namespace
    
    /**
     * View state
     */
    @State private var showError: Bool = false
    @State private var errorMessage: String?
    @Binding var date: Date
    
    /**
     * View body.
     */
    var body: some View {
        NavigationStack {
            TaskListContent(
                date: date,
                showError: $showError,
                errorMessage: $errorMessage,
                namespace: namespace
            )
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage ?? "An error occured")
        }
    }
}

private struct TaskListContent: View {
    @Environment(\.modelContext) private var modelContext
    let date: Date
    @State var draftTask: Task? = nil
    @Binding var showError: Bool
    @Binding var errorMessage: String?
    let namespace: Namespace.ID
    
    @Query var pendingTasks: [Task]
    @Query var completedTasks: [Task]
    
    init(date: Date, showError: Binding<Bool>, errorMessage: Binding<String?>, namespace: Namespace.ID) {
        self.date = date
        self._showError = showError
        self._errorMessage = errorMessage
        self.namespace = namespace
        _pendingTasks = Query(filter: Task.predicate(status: .pending, date: date))
        _completedTasks = Query(filter: Task.predicate(status: .done, date: date))
    }
    
    var body: some View {
        List {
            Section(header: Text("Tasks")) {
                ForEach(pendingTasks) { task in
                    TaskView(task: task)
                        .matchedGeometryEffect(id: task.id, in: namespace)
                }
                .onDelete { offsets in
                    for index in offsets {
                        modelContext.delete(pendingTasks[index])
                    }
                }
                if let draft = draftTask {
                    TaskView(task: draft, isDraft: true, onCommit: { name in
                        let result = Task.create(
                            name: draft.name,
                            status: .pending,
                            date: draft.date,
                            in: modelContext,
                        )
                        if case let .failure(error) = result {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                        draftTask = nil
                    }, onCancel: { draftTask = nil })
                }
            }
            Section(header: Text("Completed")) {
                ForEach(completedTasks) { task in
                    TaskView(task: task)
                        .matchedGeometryEffect(id: task.id, in: namespace)
                }
            }
        }
        .navigationTitle("Tasks")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    draftTask = Task(name: "", date: date)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .id(date) // Force view recreation when date changes to reinitialize queries with new date
    }
}

struct TaskView: View {
    @Bindable var task: Task
    @State private var showDatePicker: Bool = false
    var isDraft: Bool = false
    var onCommit: ((String) -> Void)?
    var onCancel: (() -> Void)?
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                TextField("Task name", text: $task.name)
                    .font(.headline)
                    .focused($isFocused)
                    .onAppear { if isDraft { isFocused = true } }
                    .onSubmit { onCommit?(task.name) }
                
                ClosingDatePicker(date: $task.date)
                    .labelsHidden()
                    .opacity(0)
                    .overlay {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.caption)
                                .foregroundStyle(.blue)
                            Text(DateFormatters.DDMMYYYY.string(from: task.date))
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                                .fixedSize(horizontal: true, vertical: false)
                            Spacer()
                        }
                        .allowsHitTesting(false)
                    }
            }
            Spacer()
            if isDraft {
                Button("Cancel") { onCancel?() }
                    .buttonStyle(.borderless)
            } else {
                TaskCompletionButtonView(task: task)
            }
        }
    }
}

struct TaskCompletionButtonView: View {
    @Bindable var task: Task
    
    var body: some View {
        Button(action: {
            withAnimation(.linear(duration: 0.2)) {
                task.toggleStatus()
            }
        }) {
            Image(systemName: task.status == TaskStatus.done ? "checkmark.square.fill" : "square")
        }
        .buttonStyle(.borderless)  // Stops tap hitbox spreading to parent
    }
}

#Preview {
    @Previewable @State var date = Date()
    TaskListView(date: $date)
}
