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
    
    init(
        shouldSeed: Bool,
        inMemory: Bool = false,
    ) {
        self.container = DataContainer.create(
            shouldSeed: shouldSeed,
            configuration: ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        )
        self.context = container.mainContext
    }
}
