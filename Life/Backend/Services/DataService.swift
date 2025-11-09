//
//  DataService.swift
//  Life
//
//  Created by David Fitzgerald on 09/11/2025.
//

import SwiftData

@MainActor
class DataService {
    /**
     * Service concerned with data management.
     */
    let container: ModelContainer
    let context: ModelContext
    
    init(shouldSeed: inout Bool) {
        var seed = shouldSeed
        self.container = DataContainer.create(
            shouldSeed: &seed,
            configuration: ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        )
        self.context = container.mainContext
    }
}
