//
//  VersionedSchemaV1.swift
//  Life
//
//  Created by David Fitzgerald on 28/10/2025.
//

import Foundation
import SwiftData
import CoreData

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
    
    enum TaskError: LocalizedError {
        case emptyName
        case saveFailed(Error)
        
        var errorDescription: String? {
            switch self {
            case .emptyName:
                return "Name cannot be empty."
            case .saveFailed(let error):
                return "Failed to save task: \(error.localizedDescription)"
            }
        }
    }
}

extension SchemaV1.Task {
    /**
     * Task methods.
     */
    func toggleStatus() {
        self.status = status.toggle
    }
    
    static func create(
        name: String,
        status: TaskStatus = .pending,
        date: Date = Date(),
        in context: ModelContext,
    ) -> Result<Task, SchemaV1.TaskError> {
        if name.isEmpty {
            return .failure(.emptyName)
        }

        let task = Task(name: name, status: status, date: date)
        context.insert(task)
        
        do {
            try context.save()
            return .success(task)
        } catch let error as NSError {
            context.delete(task)
            return .failure(.saveFailed(error))
        }
    }
}

extension SchemaV1.Task {
    /**
     * Task querying.
     */
    static func predicate(
        status: TaskStatus,
        date: Date? = nil
    ) -> Predicate<Task> {
        let statusValue = status.rawValue

        if let date {
            let startOfDay = Calendar.current.startOfDay(for: date)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            return #Predicate<Task> { task in
                task.statusRawValue == statusValue &&
                task.date > startOfDay &&
                task.date < endOfDay
            }
        }

        return #Predicate<Task> { task in
            task.statusRawValue == statusValue
        }
    }
}
