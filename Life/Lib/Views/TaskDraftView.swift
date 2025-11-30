//
//  TaskDraftView.swift
//  Life
//
//  Created by David Fitzgerald on 30/11/2025.
//

import SwiftUI
import SwiftData

struct TaskDraftView: View {
    @Bindable var draft: Task
    let onCommit: (String) -> Void
    let onCancel: () -> Void
    @State private var showError = false
    @State private var errorMessage: String?
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TaskView(
            task: draft,
            isDraft: true,
            commit: { name in
                let result = Task.create(
                    name: draft.name,
                    status: .pending,
                    date: draft.date,
                    in: modelContext
                )
                if case let .failure(error) = result {
                    errorMessage = error.localizedDescription
                    showError = true
                } else {
                    onCommit(name)
                }
            },
            cancel: onCancel
        )
        .id("draft-task")
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage ?? "An error occurred")
        }
    }
}

