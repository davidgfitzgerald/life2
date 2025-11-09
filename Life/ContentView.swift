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

#Preview("First Launch") {
    /**
     * This preview should reflect the behaviour within the @main app.
     *
     * Use a fresh set of user defaults to mimic first time launch.
     */
    let previewDefaults = UserDefaults(suiteName: "preview")!
    previewDefaults.removePersistentDomain(forName: "preview")

    let config = AppConfiguration(
        inMemory: true,
        userDefaults: previewDefaults,
    )
    return PreviewWrapper(config: config)
}

struct PreviewWrapper: View {
    var config: AppConfiguration

    init(config: AppConfiguration) {
        self.config = config
        /**
         * Everything below here is for dev/testing only
         * and does not reflect the behaviour in the @main app.
         */
        let now = Date()
        let dayAgo = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let context = config.dataService.context
        Timer.scheduledTimer(withTimeInterval: TimeInterval(5), repeats: false) {_ in
            context.insert(Task(name: "Delayed task", date: dayAgo, rollOn: true))
        }
        
    }
            
    var body: some View {
        ContentView()
            .configured(with: config)
    }
}
