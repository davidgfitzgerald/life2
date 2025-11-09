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
    // isFirstTimeLaunch is used to initialise data
    // on very first app load.
    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = true
    
    @State private var dayMonitor: NewDayMonitor
    private var container: ModelContainer

    init() {
        var isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstTimeLaunch")
        if UserDefaults.standard.object(forKey: "isFirstTimeLaunch") == nil {
            isFirstLaunch = true  // First time ever
        }
        self.container = DataContainer.create(
            shouldSeed: &isFirstLaunch,
            configuration: ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        )
        self._dayMonitor = State(initialValue: NewDayMonitor(onDayChange: { [container] in
            Task.roll(in: container.mainContext)
        }))
        
        
        onAppStartup(container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dayMonitor)
        }
        .modelContainer(
            container
        )
    }
}

@MainActor
func onAppStartup(_ context: ModelContext) {
    /**
     * Runs once when app launches
     */
    print("App started!")
    Task.roll(in: context)
}
