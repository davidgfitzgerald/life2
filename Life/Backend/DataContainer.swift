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
    static func create(shouldSeed: Bool, configuration: ModelConfiguration) -> ModelContainer {
        do {
            let container = try ModelContainer(
                for: schema,
                migrationPlan: MigrationPlan.self,
                configurations: [configuration],
            )
        
            if shouldSeed {
                seed(container: container)
            }
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
