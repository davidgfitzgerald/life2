//
//  SchemaV4.swift
//  Life
//
//  Created by David Fitzgerald on 09/11/2025.
//
import Foundation
import SwiftData


enum SchemaV4: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 3)
    
    static var models: [any PersistentModel.Type] {
        [
             Task.self
        ]
    }
}


extension SchemaV4 {
    @Model
    final class Task: Identifiable {
        /**
         * Raw DB fields.
         */
        var name: String // TODO rename to title
        var details: String
        var statusRawValue: String
        var date: Date
        var completedAt: Date?
        var createdAt: Date?
        var rollOn: Bool = false
        
        /**
         * Task init.
         */
        init(
            name: String,
            details: String = "",
            status: TaskStatus = TaskStatus.pending,
            date: Date = Date(),
            completedAt: Date? = nil,
            rollOn: Bool = false,
        ) {
            self.name = name
            self.details = details
            self.statusRawValue = status.rawValue
            self.date = date
            self.completedAt = completedAt
            self.createdAt = Date()
            self.rollOn = rollOn
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
    static let migrateV3toV4 = MigrationStage.lightweight(
        fromVersion: SchemaV3.self,
        toVersion: SchemaV4.self,
    )
}
