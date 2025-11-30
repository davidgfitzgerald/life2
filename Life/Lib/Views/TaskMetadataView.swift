//
//  TaskMetadataView.swift
//  Life
//
//  Created by David Fitzgerald on 30/11/2025.
//

import SwiftUI

struct TaskMetadataView: View {
    @Bindable var task: Task
    
    var body: some View {
        HStack {
            // TODO: render using grid to ensure nice alignment
            ClosingDatePicker(date: $task.date) { currentDate in
                VStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.blue)
                        .frame(height: 16)
                    Text("move")
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            
            if let completedAt = task.completedAt, let duration = task.duration {
                CompletionTimeView(completedAt: completedAt)
                DurationView(duration: duration)
            }
        }
    }
}

private struct CompletionTimeView: View {
    let completedAt: Date
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark")
                .foregroundStyle(.green)
                .frame(height: 16)
            Text(DateFormatters.HHMM.string(from: completedAt))
        }
        .font(.caption)
        .foregroundStyle(.gray)
    }
}

private struct DurationView: View {
    let duration: TimeInterval
    
    var body: some View {
        VStack {
            Image(systemName: "timer")
                .foregroundColor(.blue)
                .frame(height: 16)
            Text(DurationFormatters.terse(duration))
        }
        .font(.caption)
        .foregroundStyle(.gray)
    }
}

