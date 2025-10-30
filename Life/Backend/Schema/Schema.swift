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
typealias Task = VersionedSchemaV1.Task

let schema = Schema([
    Task.self,
])
