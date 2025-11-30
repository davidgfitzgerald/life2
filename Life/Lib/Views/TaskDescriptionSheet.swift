//
//  TaskDescriptionSheet.swift
//  Life
//
//  Created by David Fitzgerald on 30/11/2025.
//

import SwiftUI

struct TaskDescriptionSheet: View {
    @Bindable var task: Task
    @FocusState private var descriptionIsFocused: Bool
    
    var body: some View {
        VStack {
            Toggle("Roll On", isOn: $task.rollOn)
            ZStack {
                if task.details.isEmpty && !descriptionIsFocused {
                    Text("Enter description ...")
                        .foregroundStyle(.gray)
                }
                TextEditor(text: $task.details)
                    .focused($descriptionIsFocused)
                    .scrollContentBackground(.hidden)
            }
        }
        .padding()
        .padding()
        .presentationDetents([.medium, .large])
        .presentationBackground(.regularMaterial)
    }
}

