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
    
    var body: some View {
        List(tasks) { task in
            TaskView(task: task)
        }
    }
}

struct TaskView: View {
    @Bindable var task: Task

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Task name", text: $task.name)
            .font(.headline)
            Text(dateFormatter.string(from: task.date))
            .font(.subheadline)
        }
    }
}

#Preview {
    TaskListView()
}
