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

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(
            DataContainer.create(
                shouldCreateDefaults: &isFirstTimeLaunch,
                configuration: ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            )
        )
    }
}
