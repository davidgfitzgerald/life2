//
//  ContentView.swift
//  Life
//
//  Created by David Fitzgerald on 28/10/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    /**
     * View environment.
     */
    @Environment(\.modelContext) private var modelContext
    
    /**
     * View state.
     */
    @State private var date = Date()
    @State private var datePickerID = UUID()
    
    /**
     * View body.
     */
    var body: some View {
        ClosingDatePicker(date: $date)
        
        TaskListView(
            date: $date
        )
        Spacer()
    }
}

#Preview {
    var shouldSeed: Bool = true
    var configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    ContentView()
        .modelContainer(DataContainer.create(shouldSeed: &shouldSeed, configuration: configuration))
}
