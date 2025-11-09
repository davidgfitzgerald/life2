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
    private let config = AppConfiguration()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .configured(with: config)
        }
    }
}

extension View {
    func configured(with config: AppConfiguration) -> some View {
        self
            .modelContainer(config.dataService.container)
            .environment(config.backgroundTaskService.newDayMonitor)
    }
}
