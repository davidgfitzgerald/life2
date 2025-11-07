//
//  Schema.swift
//  Life
//
//  Created by David Fitzgerald on 28/10/2025.
//

import Foundation
import SwiftData

/**
 * Set active schema version here.
 */
typealias CurrentSchema = SchemaV3
let schema = Schema(CurrentSchema.models)

/**
 * Add new models here.
 */
typealias Task = CurrentSchema.Task
typealias TaskStatus = CurrentSchema.TaskStatus


enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [
            SchemaV1.self,
            SchemaV2.self,
            SchemaV3.self,
        ]
    }
    static var stages: [MigrationStage] {
        [
            migrateV1toV2,
            migrateV2toV3,
        ]
    }
}


