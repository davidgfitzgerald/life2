//
//  Tasks.swift
//  Life
//
//  Created by David Fitzgerald on 30/10/2025.
//

import SwiftUI
import SwiftData


struct TaskListView: View {
    @Query var tasks: [Task]
    @Namespace private var namespace

    var pendingTasks: [Task] {
        tasks.filter { $0.status == .pending}
    }
    var completeTasks: [Task] {
        tasks.filter { $0.status == .done}
    }
    
    var body: some View {
        List {
            Section(header: Text("Tasks")) {
                ForEach(pendingTasks) { task in
                    TaskView(task: task)
                        .matchedGeometryEffect(id: task.id, in: namespace)

                }
            }
            Section(header: Text("Completed")) {
                ForEach(completeTasks) { task in
                    TaskView(task: task)
                        .matchedGeometryEffect(id: task.id, in: namespace)
                }
            }
        }
    }
}

struct TaskView: View {
    @Bindable var task: Task
    @State private var showDatePicker: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                TextField("Task name", text: $task.name)
                    .font(.headline)
                
                DatePicker(
                    "Date",
                    selection: $task.date,
                    displayedComponents: [.date]
                )
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
            TaskCompletionButtonView(task: task)
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
    TaskListView()
}
