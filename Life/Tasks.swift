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
            ScrollViewReader { proxy in
                List {
                    if !pendingTasks.isEmpty || draftTask != nil {
                        Section(header: Text("Pending")) {
                            ForEach(pendingTasks) { task in
                                TaskView(task: task)
                                    .matchedGeometryEffect(id: "\(task.id)-pending", in: namespace)
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
                                .id("draft-task")
                            }
                        }
                    }
                    if completedTasks.isEmpty == false {
                        Section(header: Text("Completed")) {
                            ForEach(completedTasks) { task in
                                TaskView(task: task)
                                    .matchedGeometryEffect(id: "\(task.id)-completed", in: namespace)
                            }
                        }
                    }
                    if pendingTasks.isEmpty && draftTask == nil && completedTasks.isEmpty {
                        Text("No tasks yet. Add one!")
                            .foregroundStyle(.secondary)
                    }
                }
                .navigationTitle("Tasks")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            draftTask = Task(name: draftTask?.name ?? "", date: date)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    proxy.scrollTo("draft-task", anchor: .center)
                                }
                            }
                        } label: {
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .id(date)
                    }
                }
                .alert("Error", isPresented: $showError) {
                    Button("OK") { }
                } message: {
                    Text(errorMessage ?? "An error occured")
                }
                .onChange(of: date) { oldValue, newValue in
                    draftTask = nil
                }
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
    @State private var showDescription: Bool = false
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
                
                HStack {
                    ClosingDatePicker(date: $task.date) { currentDate in
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(.blue)
                        }
                    }
                    Button(action: {
                        showDescription = true
                    }, label: {
                        Text("description")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    })
                    if let completedAt = task.completedAt, let duration = task.duration {
                        VStack {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.green)
                                .frame(height: 16) // Consistent icon height

                            Text(DateFormatters.HHMM.string(from: completedAt))
                        }
                        .font(.caption)
                        .foregroundStyle(.gray)

                        VStack {
                            Image(systemName: "timer")
                                .foregroundColor(.blue)
                                .frame(height: 16) // Consistent icon height

                            Text(DurationFormatters.abbreviated.string(from: duration.magnitude) ?? "")
                        }
                        .font(.caption)
                        .foregroundStyle(.gray)
                    }
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
        .sheet(isPresented: $showDescription) {
            TextEditor(text: $task.details)
            .scrollContentBackground(.hidden)
            .padding()
            .padding()
            .presentationDetents([.medium, .large])
            .presentationBackground(.regularMaterial)
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
