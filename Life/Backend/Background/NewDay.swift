//
//  NewDay.swift
//  Life
//
//  Created by David Fitzgerald on 09/11/2025.
//
import Foundation


@Observable
class NewDayMonitor {
    /**
     * Class that monitors if a new day has occurred (the clock has struck midnight)
     * and triggers registered callback events.
     */
    var dayChangeCount: Int = 0
    var lastChangeDate: Date? = nil
    let onDayChange: () -> Void
    private var timer: Timer?
    private var currentDay: Date?
    
    init(onDayChange: @escaping () -> Void) {
        self.onDayChange = onDayChange
        startMonitoring()
    }
    
    func startMonitoring() {
        currentDay = Calendar.current.startOfDay(for: Date())
        scheduleNextCheck()
    }
    
    private func scheduleNextCheck() {
        timer?.invalidate()
        
        // Calculate duration until next midnight
        let now = Date()
        let startOfToday = Calendar.current.startOfDay(for: now)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!
        let timeUntilMidnight = tomorrow.timeIntervalSince(now)
        
        // Schedule timer to fire just after midnight
        timer = Timer.scheduledTimer(withTimeInterval: timeUntilMidnight + 1, repeats: false) { [weak self] _ in
                self?.checkDayChange()
            }
        }
    
    private func checkDayChange() {
        let today = Calendar.current.startOfDay(for: Date())

        let dayHasChanged = today != currentDay
        
        if dayHasChanged {
            currentDay = today
            dayChangeCount += 1
            lastChangeDate = Date()
            onDayChange()
        }
        
        scheduleNextCheck()
    }

}
