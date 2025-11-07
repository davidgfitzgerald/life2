//
//  VersionedSchemaV1.swift
//  Life
//
//  Created by David Fitzgerald on 28/10/2025.
//

import Foundation
import SwiftData


enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 0)
    
    static var models: [any PersistentModel.Type] {
        [
             Task.self
        ]
    }
}


extension SchemaV1 {
    @Model
    final class Task: Identifiable {
        /**
         * Raw DB fields.
         */
        var name: String
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
            status: TaskStatus = TaskStatus.pending,
            date: Date = Date(),
        ) {
            self.date = date
            self.name = name
            self.statusRawValue = status.rawValue
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
