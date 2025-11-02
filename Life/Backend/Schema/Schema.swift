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
typealias Task = SchemaV1.Task
typealias TaskStatus = SchemaV1.TaskStatus

let schema = Schema([
    Task.self,
])
