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
    static func create(shouldSeed: inout Bool, configuration: ModelConfiguration) -> ModelContainer {
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
        
            if shouldSeed {
                shouldSeed = false
                seed(container: container)
            }
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

@MainActor
func seed(container: ModelContainer) {
    let now = Date()
    guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now) else {
        fatalError("Failed to calculate yesterday") // This should never happen
    }
    guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) else {
        fatalError("Failed to calculate tomorrow") // This should never happen
    }
    
    let task1 = Task(name: "Summat", date: yesterday)
    let task2 = Task(name: "Blah", date: now)
    let task3 = Task(name: "Read", date: tomorrow)
    
    container.mainContext.insertAll([task1, task2, task3])
    
    try? container.mainContext.save()
}
