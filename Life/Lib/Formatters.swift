//
//  Date.swift
//  Life
//
//  Created by David Fitzgerald on 30/10/2025.
//

import Foundation

// TODO move to constants file...?
let MINUTE = 60
let HOUR = 60*MINUTE
let DAY = 24*HOUR
let MONTH = 30*DAY // TODO handle variation
let YEAR = 365*DAY // TODO handle variation

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
        /**
         * Renders something like this:
         *
         * 1s
         * 2s
         * ...
         * 10s
         * ...
         * 59s
         * 1m
         * ...
         * 1m59s
         * 2m
         * ...
         * 9m59s
         * 10m
         * ...
         * 59m59s
         * 1h
         * 1h1m
         * ...
         * 1h59m
         * 2h
         * ...
         * 23h59m
         * 1d
         * 1d1h
         * ...
         * 1d23h
         * 2d
         * ...
         * 6d
         * 7d
         * 8d
         * ...
         * 13d
         * ...
         * 20d
         * 21d
         * ...
         * 28d
         * 29d
         * 1M
         * ...
         * 1M5d
         * ...
         * 1M29d
         * 2M
         * ...
         * 11M29d
         * 1Y
         * 1Y1M
         * ...
         * 1Y11M
         * 2Y
         * ...
         *
         * (By no means perfect at this stage)
         */
        var toRender: [String] = []
        var seconds: Int
        
        let yearDivision = Int(interval).quotientAndRemainder(dividingBy: YEAR)
        let years = yearDivision.quotient
        seconds = yearDivision.remainder
        
        let monthDivision = seconds.quotientAndRemainder(dividingBy: MONTH)
        let months = monthDivision.quotient
        seconds = monthDivision.remainder

        let dayDivision = seconds.quotientAndRemainder(dividingBy: DAY)
        let days = dayDivision.quotient
        seconds = dayDivision.remainder
        
        let hourDivision = seconds.quotientAndRemainder(dividingBy: HOUR)
        let hours = hourDivision.quotient
        seconds = hourDivision.remainder
        
        let minuteDivision = seconds.quotientAndRemainder(dividingBy: MINUTE)
        let minutes = minuteDivision.quotient
        seconds = minuteDivision.remainder
        
        // TODO, refactor into loop or something more elegant.
        if toRender.count > 0 {
            if years > 0 {
                toRender.append("\(years)Y")
            }
            return toRender.joined(separator: "")
        }
        if years > 0 {
            toRender.append("\(years)Y")
        }
        
        if toRender.count > 0 {
            if months > 0 {
                toRender.append("\(months)M")
            }
            return toRender.joined(separator: "")
        }
        if months > 0 {
            toRender.append("\(months)M")
        }
        
        if toRender.count > 0 {
            if days > 0 {
                toRender.append("\(days)d")
            }
            return toRender.joined(separator: "")
        }
        if days > 0 {
            toRender.append("\(days)d")
        }
        
        if toRender.count > 0 {
            if hours > 0 {
                toRender.append("\(hours)h")
            }
            return toRender.joined(separator: "")
        }
        if hours > 0 {
            toRender.append("\(hours)h")
        }

        if toRender.count > 0 {
            if minutes > 0 {
                toRender.append("\(minutes)m")
            }
            return toRender.joined(separator: "")
        }
        if minutes > 0 {
            toRender.append("\(minutes)m")
        }
        
        if toRender.count > 0 {
            if seconds > 0 {
                toRender.append("\(seconds)s")
            }
            return toRender.joined(separator: "")
        }
        if seconds > 0 {
            toRender.append("\(seconds)s")
        }
    
        return toRender.joined(separator: "")

    }
}
