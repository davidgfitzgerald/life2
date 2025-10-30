//
//  ModelContext.swift
//  Life
//
//  Created by David Fitzgerald on 30/10/2025.
//

import Foundation
import SwiftData

extension ModelContext {
    func insertAll<T: PersistentModel>(_ items: [T]) {
        /**
         * Helper to insert an iterable of items into the
         * database.
         *
         * Usage:
         *
         *      modelContext.insertAll(items)
         */
        items.forEach { insert($0) }
    }
}
