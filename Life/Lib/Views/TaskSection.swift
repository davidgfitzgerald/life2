//
//  TaskSection.swift
//  Life
//
//  Created by David Fitzgerald on 30/11/2025.
//

import SwiftUI
import SwiftData

struct TaskSection: View {
    let tasks: [Task]
    let title: String
    let namespace: Namespace.ID
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        if !tasks.isEmpty {
            Section(header: Text(title)) {
                ForEach(tasks) { task in
                    TaskView(task: task)
                        .matchedGeometryEffect(
                            id: "\(task.id)-\(title.lowercased())",
                            in: namespace
                        )
                }
                .onDelete { offsets in
                    for index in offsets {
                        modelContext.delete(tasks[index])
                    }
                }
            }
        }
    }
}

