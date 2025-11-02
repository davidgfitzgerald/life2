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
        @Attribute(.unique)
        var name: String
        var status: TaskStatus
        var date: Date

        init(
            name: String,
            status: TaskStatus = TaskStatus.pending,
            date: Date = Date(),
        ) {
            self.date = date
            self.name = name
            self.status = status
        }
    }
    
    enum TaskStatus: String, Codable {
        case pending
        case done
    }
}

extension VersionedSchemaV1.Task {

    func toggleStatus() {
        self.status = status == .done ? .pending : .done
    }
}
