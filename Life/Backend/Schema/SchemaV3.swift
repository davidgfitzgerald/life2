//
//  SchemaV3.swift
//  Life
//
//  Created by David Fitzgerald on 07/11/2025.
//

import Foundation
import SwiftData


enum SchemaV3: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 1)
    
    static var models: [any PersistentModel.Type] {
        [
             Task.self
        ]
    }
}


extension SchemaV3 {
    @Model
    final class Task: Identifiable {
        /**
         * Raw DB fields.
         */
        var name: String
        var details: String
        var statusRawValue: String
        var date: Date
        var completedAt: Date?
        var createdAt: Date
        
        /**
         * Task init.
         */
        init(
            name: String,
            details: String = "",
            status: TaskStatus = TaskStatus.pending,
            date: Date = Date(),
            completedAt: Date? = nil,
        ) {
            self.name = name
            self.details = details
            self.statusRawValue = status.rawValue
            self.date = date
            self.completedAt = completedAt
            self.createdAt = Date()
        }
    }
    
    /**
     * Task enums.
     */
    enum TaskStatus: String, Codable, CaseIterable {
        case pending
        case done
        
        var toggle: TaskStatus {
            self == .done ? .pending : .done
        }
    }
}

extension MigrationPlan {
    /**
     * Migration info:
     *
     * - details field added to Task
     * - details defaults to an empty string for pre-existing tasks
     */
    static let migrateV2toV3 = MigrationStage.lightweight(
        fromVersion: SchemaV2.self,
        toVersion: SchemaV3.self,
    )
}
