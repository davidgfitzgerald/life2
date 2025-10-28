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

    var body: some View {
        Text("Hello, World!")
    }

}

#Preview {
    var shouldCreateDefaults: Bool = false
    var configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    ContentView()
        .modelContainer(DataContainer.create(shouldCreateDefaults: &shouldCreateDefaults, configuration: configuration))
}
