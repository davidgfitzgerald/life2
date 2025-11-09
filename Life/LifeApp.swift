//
//  LifeApp.swift
//  Life
//
//  Created by David Fitzgerald on 28/10/2025.
//

import SwiftUI
import SwiftData

@main
struct LifeApp: App {
    private let backgroundTaskService: BackgroundTaskService
    private let dataService: DataService

    
    init() {
        var isFirstLaunch = StartupService.checkFirstLaunch()
        self.dataService = DataService(shouldSeed: &isFirstLaunch)
        self.backgroundTaskService = BackgroundTaskService(container: dataService.container)
        
        StartupService.runStartupTasks(context: dataService.context)
        
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(backgroundTaskService.newDayMonitor)
        }
        .modelContainer(
            dataService.container
        )
    }
}
