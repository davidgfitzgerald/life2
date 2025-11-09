//
//  BackgroundTaskService.swift
//  Life
//
//  Created by David Fitzgerald on 09/11/2025.
//

import SwiftData


@MainActor
class BackgroundTaskService {
    /**
     * Service concerned with running background tasks.
     */
    let newDayMonitor: NewDayMonitor
    
    init(container: ModelContainer) {
        self.newDayMonitor = NewDayMonitor(onDayChange: { [container] in
            Task.roll(in: container.mainContext)
        })
    }
}
