//
//  Tasks.swift
//  Life
//
//  Created by David Fitzgerald on 30/10/2025.
//

import SwiftUI
import SwiftData


struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var tasks: [Task]
    @Namespace private var namespace
    
    @State private var draftTask: Task?
    @Binding var date: Date
    
    var pendingTasks: [Task] {
        tasks.filter { $0.status == .pending}
    }
    var completeTasks: [Task] {
        tasks.filter { $0.status == .done}
    }
    
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
                            guard !name.isEmpty, !tasks.contains(where: { $0.name == name }) else {
                                draftTask = nil
                                return
                            }
                            modelContext.insert(draft)
                            draftTask = nil
                        }, onCancel: { draftTask = nil })
                    }
                }
                Section(header: Text("Completed")) {
                    ForEach(completeTasks) { task in
                        TaskView(task: task)
                            .matchedGeometryEffect(id: task.id, in: namespace)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { draftTask = Task(name: "", date: date) }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
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
                
                DatePicker("Date", selection: $task.date, displayedComponents: [.date])
                    .labelsHidden()
                    .opacity(0.02)
                    .overlay {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.caption)
                                .foregroundStyle(.blue)
                            Text(DateFormatters.DDMMYYYY.string(from: task.date))
                                .font(.subheadline)
                                .foregroundStyle(.blue)
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
