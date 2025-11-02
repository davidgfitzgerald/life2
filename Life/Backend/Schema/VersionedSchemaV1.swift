//
//  VersionedSchemaV1.swift
//  Life
//
//  Created by David Fitzgerald on 28/10/2025.
//

import Foundation
import SwiftData

enum VersionedSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 0)
    
    static var models: [any PersistentModel.Type] {
        [
             Task.self
        ]
    }
}

extension VersionedSchemaV1 {
    @Model
    final class Task: Identifiable {
        /**
         * Raw DB fields.
         */
        @Attribute(.unique)
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
    }
}

extension VersionedSchemaV1.Task {
    /**
     * Task methods.
     */
    func toggleStatus() {
        self.status = status == .done ? .pending : .done
    }
}

extension VersionedSchemaV1.Task {
    /**
     * Task querying.
     */
    static func predicate(status: TaskStatus) -> Predicate<Task> {
        let statusValue = status.rawValue
        return #Predicate<Task> { task in
            task.statusRawValue == statusValue
        }
    }
}
