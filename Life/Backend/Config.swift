//
//  Config.swift
//  Life
//
//  Created by David Fitzgerald on 09/11/2025.
//

import Foundation
import SwiftData


@MainActor
class AppConfiguration {
    /**
     * App configuration object for use at the top-level.
     *
     * Extracted out to ensure as consistent as possible
     * behaviour between production app and previews.
     */
    let backgroundTaskService: BackgroundTaskService
    let dataService: DataService
    let startupService: StartupService
    
    init(
        inMemory: Bool = false,
        userDefaults: UserDefaults = .standard
    ) {
        self.startupService = StartupService(userDefaults: userDefaults)
        self.dataService = DataService(
            shouldSeed: startupService.checkFirstLaunch(),
            inMemory: inMemory,
        )
        self.backgroundTaskService = BackgroundTaskService(container: dataService.container)
        
        startupService.runStartupTasks(context: dataService.context)
    }
}
