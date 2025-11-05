//
//  Task.swift
//  Life
//
//  Created by David Fitzgerald on 05/11/2025.
//

import Foundation
import SwiftData


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


extension Task {
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
    ) -> Result<Task, TaskError> {
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


extension Task {
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
