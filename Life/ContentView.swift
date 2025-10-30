//
//  ContentView.swift
//  Life
//
//  Created by David Fitzgerald on 28/10/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var date = Date()

    var body: some View {
        DatePicker(
            "Date",
            selection: $date,
            displayedComponents: [.date]
        )
        .labelsHidden()
        TaskListView()
        Spacer()
    }

}

#Preview {
    var shouldCreateDefaults: Bool = true
    var configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    ContentView()
        .modelContainer(DataContainer.create(shouldCreateDefaults: &shouldCreateDefaults, configuration: configuration))
}
