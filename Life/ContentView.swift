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
    private let backgroundTaskService: BackgroundTaskService
    private let dataService: DataService

    init() {
        var isFirstLaunch = StartupService.checkFirstLaunch()
        self.dataService = DataService(shouldSeed: &isFirstLaunch)
        self.backgroundTaskService = BackgroundTaskService(container: dataService.container)
        
        StartupService.runStartupTasks(context: dataService.context)
        
        /**
         * Everything below here is for dev/testing only
         * and does not reflect the behaviour in the @main app.
         */
        let now = Date()
        let dayAgo = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let context = dataService.context
        Timer.scheduledTimer(withTimeInterval: TimeInterval(5), repeats: false) {_ in
            context.insert(Task(name: "Delayed task", date: dayAgo, rollOn: true))
        }
        
    }
            
    var body: some View {
        ContentView()
            .modelContainer(dataService.container)
            .environment(backgroundTaskService.newDayMonitor)
    }
}
