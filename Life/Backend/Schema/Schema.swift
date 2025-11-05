//
//  Schema.swift
//  Life
//
//  Created by David Fitzgerald on 28/10/2025.
//

import Foundation
import SwiftData

/**
 * Set active models here.
 */
typealias Task = SchemaV2.Task
typealias TaskStatus = SchemaV2.TaskStatus
let schema = Schema(SchemaV2.models)


enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            SchemaV1.self,
            SchemaV2.self,
        ]
    }
    static var stages: [MigrationStage] {
        [
            migrateV1toV2,
        ]
    }
}


