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
    let startupService: StartupService
    let dataService: DataService
    let backgroundTaskService: BackgroundTaskService

//    let config =
    init() {
        self.startupService = StartupService(userDefaults: .standard)
        self.dataService = DataService(
            shouldSeed: startupService.checkFirstLaunch(),
            inMemory: false,
        )
        self.backgroundTaskService = BackgroundTaskService(container: dataService.container, monitorType: NewDayMonitor.self)
        
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .configured(
                    with:
                        AppConfiguration(
                            startupService: startupService,
                            dataService: dataService,
                            backgroundTaskService: backgroundTaskService,
                        )
                )
        }
    }
}

extension View {
    func configured(with config: AppConfiguration) -> some View {
        self
            .modelContainer(config.dataService.container)
            .environment(config.backgroundTaskService.monitor)
    }
}
