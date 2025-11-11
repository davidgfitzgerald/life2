//
//  BackgroundTaskService.swift
//  Life
//
//  Created by David Fitzgerald on 09/11/2025.
//

import SwiftData
import Foundation


@MainActor
class BackgroundTaskService {
    let monitor: AnyTemporalMonitor
    
    init(
        container: ModelContainer,
        monitorType: any TemporalMonitor.Type,
        interval: TimeInterval? = nil,
    ) {
        let actualMonitor: any TemporalMonitor = monitorType.init(
            onTransition: { [container] in
                Task.rollover(in: container.mainContext)
            },
            interval: interval
        )
        
        self.monitor = AnyTemporalMonitor(actualMonitor)
    }
}
