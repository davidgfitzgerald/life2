//
//  NewDay.swift
//  Life
//
//  Created by David Fitzgerald on 09/11/2025.
//
import Foundation


protocol TemporalMonitor {
    var transitionCount: Int { get }
    var lastTransition: Date? { get }

    init(onTransition: @escaping () -> Void, interval: TimeInterval?)
    func start()
    func scheduleNextCheck()
    func hasElapsed(by newTime: Date) -> Bool
    func checkForTransition()
}

@Observable
class AnyTemporalMonitor {
    private let _monitor: any TemporalMonitor
    
    var transitionCount: Int { _monitor.transitionCount }
    var lastTransition: Date? { _monitor.lastTransition }
    
    init<T: TemporalMonitor>(_ monitor: T) {
        self._monitor = monitor
    }
}


@Observable
class NewDayMonitor: TemporalMonitor {
    /**
     * Class that monitors if a new day has occurred (the clock has struck midnight)
     * and triggers a callback.
     */
    var transitionCount: Int = 0
    var lastTransition: Date? = nil
    let onTransition: () -> Void
    private var timer: Timer?
    private var currentDay: Date?
    
    required init(onTransition: @escaping () -> Void, interval: TimeInterval? = nil) {
        self.onTransition = onTransition
        start()
    }
    
    internal func start() {
        currentDay = Calendar.current.startOfDay(for: Date())
        scheduleNextCheck()
    }
    
    internal func scheduleNextCheck() {
        timer?.invalidate()
        
        // Calculate duration until next midnight
        let now = Date()
        let startOfToday = Calendar.current.startOfDay(for: now)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!
        let timeUntilMidnight = tomorrow.timeIntervalSince(now)
        
        // Schedule timer to fire just after midnight
        timer = Timer.scheduledTimer(withTimeInterval: timeUntilMidnight + 1, repeats: false) { [weak self] _ in
                self?.checkForTransition()
            }
        }
    
    internal func hasElapsed(by newTime: Date) -> Bool {
        let dayHasChanged = newTime != currentDay
        return dayHasChanged
    }
    
    internal func checkForTransition() {
        let today = Calendar.current.startOfDay(for: Date())
        if hasElapsed(by: today) {
            currentDay = today
            transitionCount += 1
            lastTransition = Date()
            onTransition()
        }
        
        scheduleNextCheck()
    }

}


@Observable
class IntervalMonitor: TemporalMonitor {
    /**
     * Class that monitors if some amount of seconds has elapsed
     * and triggers a callback.
     */

    /**
     * Required vars.
     */
    var transitionCount: Int = 0
    var lastTransition: Date? = nil
    let onTransition: () -> Void

    /**
     * Implementation vars.
     */
    var interval: TimeInterval
    private var timer: Timer?
    private var lastCheckedAt: Date?
    
    required init(onTransition: @escaping () -> Void, interval: TimeInterval? = nil) {
        self.onTransition = onTransition
        self.interval = interval ?? -1

        if self.interval > 0 {
            start()
        } else {
            fatalError(
                "Must pass a positive time interval into the IntervalMonitor initializer."
            )
        }
    }
    
    internal func start() {
        lastCheckedAt = Date()
        scheduleNextCheck()
    }
    
    internal func scheduleNextCheck() {
        timer?.invalidate()
        
        // Schedule timer to fire just after midnight
        timer = Timer.scheduledTimer(withTimeInterval: interval + 1, repeats: false) { [weak self] _ in
                self?.checkForTransition()
            }
        }
    
    internal func hasElapsed(by newTime: Date) -> Bool {
        let now = Date()

        let intervalHasElapsed = now > (lastCheckedAt ?? now) + interval
        return intervalHasElapsed
    }
    
    internal func checkForTransition() {
        let now = Date()

        if hasElapsed(by: now) {
            transitionCount += 1
            lastTransition = now
            onTransition()
        }
        
        lastCheckedAt = now
        scheduleNextCheck()
    }

}
