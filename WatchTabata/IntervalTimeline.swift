//
//  IntervalTimeline.swift
//  WatchTabata
//
//  Created by Kirill Ushkov on 19.04.2023.
//

import Foundation
import Models

class IntervalTimeline {
    struct Event: Equatable {
        enum EventType: Equatable {
            case phase
            case pause
        }
        var startDate: Date
        var endDate: Date?
        var type: EventType
        var phase: TrainingPhasesModel.Phase?
        
        var isFinished: Bool {
            return endDate != nil
        }
        
        var duration: TimeInterval {
            guard let end = endDate else { return 0 }
            return end.timeIntervalSince(startDate)
        }
    }

    let startDate: Date
    let phases: [TrainingPhasesModel.Phase]
    
    private var events: [Event] = []
    
    private var pauseDate: Date?
    
    init(startDate: Date, phases: [TrainingPhasesModel.Phase]) {
        self.startDate = startDate
        self.phases = phases
        
        createEvents()
    }
    
    private func createEvents() {
        var latestDate = startDate
        for phase in phases {
            let event = Event(startDate: latestDate, endDate: latestDate.addingTimeInterval(phase.duration), type: .phase, phase: phase)
            events.append(event)
            latestDate = latestDate.addingTimeInterval(phase.duration)
        }
    }
    
    func pause() {
        let currentDate = Date()
        guard let currentEvent = findEvent(for: currentDate), let index = events.firstIndex(where: {$0 == currentEvent}) else { return }
        let event = Event(startDate: currentDate, type: .pause)
        events.insert(event, at: index + 1)
    }
    
    func resume() {
        guard var pauseEvent = findLatestPause(), let index = events.firstIndex(where: { $0 == pauseEvent }) else { return }
        pauseEvent.endDate = Date()
        let pauseInterval = pauseEvent.duration
        
        for i in index+1..<events.count {
            events[i].startDate = events[i].startDate.addingTimeInterval(pauseInterval)
            events[i].endDate = events[i].endDate?.addingTimeInterval(pauseInterval)
        }
    }
    
    func findLatestPause() -> Event? {
        events.first(where: { $0.type == .pause && $0.endDate == nil })
    }
    
    func findEvent(for date: Date) -> Event? {
        events.filter { event in
            guard event.type == Event.EventType.phase, let endDate = event.endDate else { return false }
            return date >= event.startDate && date <= endDate
        }.first
    }
}
