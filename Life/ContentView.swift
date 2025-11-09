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
    
    /**
     * View body.
     */
    var body: some View {
        ClosingDatePicker(date: $date)
        TaskListView(
            date: date
        )
        DebugView()
    }
}

#Preview {
    PreviewWrapper()
}

struct PreviewWrapper: View {
    /**
     * This preview should reflect the behaviour within the @main app.
     */
    @State var newDayMonitor: NewDayMonitor
    let container: ModelContainer
    
    init() {
        var shouldSeed = true
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        self.container = DataContainer.create(shouldSeed: &shouldSeed, configuration: config)
        let context = ModelContext(container)
        
        self._newDayMonitor = State(initialValue: NewDayMonitor(onDayChange: {
            Task.roll(in: context)
        }))
        onAppStartup(context)
        
        /**
         * Everything below here is for dev/testing only
         * and does not reflect the behaviour in the @main app.
         */
        let now = Date()
        let dayAgo = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        Timer.scheduledTimer(withTimeInterval: TimeInterval(5), repeats: false) {_ in 
            context.insert(Task(name: "Delayed task", date: dayAgo, rollOn: true))
        }
    }
            
    var body: some View {
        ContentView()
            .modelContainer(container)
            .environment(newDayMonitor)
    }
}
