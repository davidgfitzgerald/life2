//
//  StartupService.swift
//  Life
//
//  Created by David Fitzgerald on 09/11/2025.
//

import Foundation
import SwiftData


@MainActor
class StartupService {
    /**
     * Service concerned with app startup behaviour.
     */
    private static let firstLaunchKey = "isFirstTimeLaunch"
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func checkFirstLaunch() -> Bool {
        if userDefaults.object(forKey: StartupService.firstLaunchKey) == nil {
            print("setting firstLaunch to true")
            return true
        }
        print("firstLaunch already set to \(userDefaults.bool(forKey: StartupService.firstLaunchKey))")
        return userDefaults.bool(forKey: StartupService.firstLaunchKey)
    }
    
    func runStartupTasks(context: ModelContext) {
        print("App started!")
        Task.roll(in: context)
        
        print("setting firstLaunch to false")
        userDefaults.set(false, forKey: StartupService.firstLaunchKey)
    }
}
