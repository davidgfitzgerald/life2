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
                                TaskView(task: draft, isDraft: true, commit: { name in
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
                                }, cancel: { draftTask = nil })
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
                            .onDelete { offsets in
                                for index in offsets {
                                    modelContext.delete(completedTasks[index])
                                }
                            }
                        }
                    }
                    if pendingTasks.isEmpty && draftTask == nil && completedTasks.isEmpty {
                        Text("No tasks yet. Add one!")
                            .foregroundStyle(.secondary)
                    }
                }
                .navigationTitle("Tasks")
                .toolbar(content: {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            draftTask = Task(name: draftTask?.name ?? "", date: date)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    proxy.scrollTo("draft-task", anchor: .top)
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
                })
                .alert("Error", isPresented: $showError) {
                    Button("OK") { }
                } message: {
                    Text(errorMessage ?? "An error occured")
                }
                .onChange(of: date) { oldValue, newValue in
                    draftTask = nil
                }
            }.scrollDismissesKeyboard(.interactively)
        }
    }
}


struct TaskView: View {
    /**
     * View args.
     */
    @Bindable var task: Task
    var isDraft: Bool = false
    var commit: ((String) -> Void)?
    var cancel: (() -> Void)?

    /**
     * View state.
     */
    @State private var showDatePicker: Bool = false
    @State private var showDescription: Bool = false
    @FocusState private var nameIsFocused: Bool
    
    /**
     * TMP
     *
     * TODO, make this more robust and render nicely system agnostic (improve/test responsiveness).
     */
    let minNameWidth: CGFloat = 100
    let maxNameWidth: CGFloat = 250
    func textWidth(_ text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 17) // Match TextField font size
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        let width = size.width + 20 // Add padding for cursor and margins
        return width
    }
    func renderWidth(_ width: CGFloat) -> CGFloat {
        return min(max(textWidth(task.name), minNameWidth), maxNameWidth)
    }

    /**
     * View body.
     */
    var body: some View {
        Button(action: {
            showDescription = true
        },label: {
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        TextField("Task name", text: $task.name)
                            .font(.headline)
                            .focused($nameIsFocused)
                            .onAppear { if isDraft { nameIsFocused = true } }
                            .onSubmit { commit?(task.name) }
                            .frame(width: renderWidth(textWidth(task.name)))
                            .padding(4)
                            .background(.gray.opacity(0.03))
                            .cornerRadius(8)
                    }
                    
                    TaskMetadataView(task: task)
                }
                Spacer()
                if isDraft {
                    Button("Cancel") { cancel?() }
                        .buttonStyle(.borderless)
                } else {
                    TaskCompletionButtonView(task: task)
                }
            }
            .sheet(isPresented: $showDescription) {
                TaskDescriptionSheet(task: task)
            }
            .onChange(of: nameIsFocused) { oldValue, newValue in
                if !newValue && task.name.isEmpty {
                    cancel?()
                }
            }
        })
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

struct DebugView: View {
    @Environment(AnyTemporalMonitor.self) private var monitor
    @State var opacity: Int = 1
    
    var body: some View {
        ZStack {
            VStack {
                Text("Days changed: \(monitor.transitionCount)")
                Text("Last change: \(monitor.lastTransition?.description ?? "Never")")
            }
                .opacity(Double(opacity))
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    opacity = (opacity + 1) % 2
                }
        }
        .frame(height: 50)

    }
}

#Preview("TaskListView") {
    TaskListView(date: Date())
}
