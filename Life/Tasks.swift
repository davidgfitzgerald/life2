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
     * View state.
     */
    let date: Date
    @State var draftTask: Task? = nil
    @State var showError: Bool = false
    @State var errorMessage: String? = nil
    
    /**
     * View queries.
     */
    @Query var pendingTasks: [Task]
    @Query var completedTasks: [Task]
    
    /**
     * View init.
     */
    init(date: Date) {
        self.date = date
        _pendingTasks = Query(filter: Task.predicate(status: .pending, date: date))
        _completedTasks = Query(filter: Task.predicate(status: .done, date: date))
    }
    
    /**
     * View body.
     */
    var body: some View {

        NavigationStack {
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
            .alert("Error", isPresented: $showError) {
                Button("OK") { }
            } message: {
                Text(errorMessage ?? "An error occured")
            }
        }
    }
}

struct TaskView: View {
    /**
     * View args.
     */
    @Bindable var task: Task
    var isDraft: Bool = false
    var onCommit: ((String) -> Void)?
    var onCancel: (() -> Void)?

    /**
     * View state.
     */
    @State private var showDatePicker: Bool = false
    @FocusState private var isFocused: Bool

    /**
     * View body.
     */
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
    /**
     * View args.
     */
    @Bindable var task: Task
    
    /**
     * View body.
     */
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

#Preview("TaskListView") {
    TaskListView(date: Date())
}
