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
    // isFirstTimeLaunch is used to initialise data
    // on very first app load.
//    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = true
    
    static func checkFirstLaunch() -> Bool {
        var isFirst = UserDefaults.standard.bool(forKey: "isFirstTimeLaunch")
        if UserDefaults.standard.object(forKey: "isFirstTimeLaunch") == nil {
            isFirst = true
        }
        return isFirst
    }
    
    static func runStartupTasks(context: ModelContext) {
        print("App started!")
        Task.roll(in: context)
    }
}
