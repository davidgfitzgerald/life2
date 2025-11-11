//
//  Config.swift
//  Life
//
//  Created by David Fitzgerald on 09/11/2025.
//

import Foundation
import SwiftData


@MainActor
struct AppConfiguration {
    /**
     * App configuration object for use at the top-level.
     *
     * Extracted out to ensure as consistent as possible
     * behaviour between production app and previews.
     */
    let startupService: StartupService
    let dataService: DataService
    let backgroundTaskService: BackgroundTaskService
}
