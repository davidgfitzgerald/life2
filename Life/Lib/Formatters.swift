//
//  Date.swift
//  Life
//
//  Created by David Fitzgerald on 30/10/2025.
//

import Foundation

enum DateFormatters {
    static let DDMMYYYY: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    static let HHMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

enum DurationFormatters {
    static let abbreviated: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated // "2h 5m 30s"
        formatter.zeroFormattingBehavior = .dropAll
        return formatter
    }()
    
    static let short: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short // "2 hr, 5 min, 30 sec"
        return formatter
    }()
    
    static func terse(_ interval: TimeInterval) -> String {
        // TODO
        let seconds = Int(interval)
        return ""
    }
}
