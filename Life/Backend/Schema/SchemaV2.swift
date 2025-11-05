//
//  SchemaV2.swift
//  Life
//
//  Created by David Fitzgerald on 05/11/2025.
//
import Foundation
import SwiftData


enum SchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 1)
    
    static var models: [any PersistentModel.Type] {
        [
             Task.self
        ]
    }
}


extension SchemaV2 {
    @Model
    final class Task: Identifiable {
        /**
         * Raw DB fields.
         */
        var name: String
        var details: String
        var statusRawValue: String
        var date: Date
        
        /**
         * Computed properties
         */
        var status: TaskStatus {
            get {
                TaskStatus(rawValue: statusRawValue) ?? .pending
            }
            set {
                statusRawValue = newValue.rawValue
            }
        }
        
        /**
         * Task init.
         */
        init(
            name: String,
            details: String = "",
            status: TaskStatus = TaskStatus.pending,
            date: Date = Date(),
        ) {
            self.name = name
            self.details = details
            self.statusRawValue = status.rawValue
            self.date = date
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
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: SchemaV1.self,
        toVersion: SchemaV2.self,
    )
}
