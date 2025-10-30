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
        var date: Date

        @Attribute(.unique)
        var name: String

        init(date: Date = Date(), name: String) {
            self.date = date
            self.name = name
        }
    }
}
