//
//  Seed.swift
//  Life
//
//  Created by David Fitzgerald on 07/11/2025.
//

import Foundation
import SwiftData


@MainActor
func seed(container: ModelContainer) {
    let now = Date()

    guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now) else {
        fatalError("Failed to calculate yesterday") // This should never happen
    }
    guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) else {
        fatalError("Failed to calculate tomorrow") // This should never happen
    }
    let startOfToday = Calendar.current.startOfDay(for: now)

    guard let beforeNow = Calendar.current.date(byAdding: .second, value: 365*DAY+2*HOUR+39*MINUTE+59, to: now) else {
        fatalError("Failed to calculate some time in the past") // This should never happen
    }

    container.mainContext.insertAll([
        Task(name: "Summat", date: yesterday),
        Task(name: "Immediately rolled over", date: yesterday, rollOn: true),
        Task(name: "Blah", date: now),
        Task(name: "Completed", status: .done, date: now, completedAt: startOfToday),
        Task(name: "Before", status: .done, date: now, completedAt: beforeNow),
        Task(name: "Read", date: tomorrow),
    ])
    
    try? container.mainContext.save()
}
