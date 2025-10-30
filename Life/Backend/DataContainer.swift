//
//  DataContainer.swift
//  Life
//
//  Created by David Fitzgerald on 28/10/2025.
//

import Foundation
import SwiftData

actor DataContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool, configuration: ModelConfiguration) -> ModelContainer {
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
        
            if shouldCreateDefaults {
                shouldCreateDefaults = false
                createDefaults(container: container)
            }
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

@MainActor
func createDefaults(container: ModelContainer) {
    let task1 = Task(name: "Read")
    
    container.mainContext.insert(task1)
    
    try? container.mainContext.save()
}
