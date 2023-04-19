//
//  TrainingInfo.swift
//  WatchTabata
//
//  Created by Kirill Ushkov on 17.04.2023.
//

import SwiftUI
import Models
import HealthKit

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    @State private var timeFormatter = ElapsedTimeFormatter()

    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.semibold)
    }
}

class ElapsedTimeFormatter: Formatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }

        guard let formattedString = componentsFormatter.string(from: time) else {
            return nil
        }

        return formattedString
    }
}


struct TrainingInfo: View {
    @EnvironmentObject var trainingManager: TrainingManager
    
    var body: some View {
        TimelineView(
            InfoTimelineSchedule(from: trainingManager.builder?.startDate ?? Date(),
                                 isPaused: trainingManager.session?.state == .paused)) { context in
                                     VStack(alignment: .leading) {
//                                         if let event = trainingManager.intervalTimeLine?.findEvent(for: context.date) {
//                                             Text(event.phase.title)
//                                         }
                                         if let title = trainingManager.intervalTimeLine?.findEvent(for: context.date)?.phase?.title {
                                             Text(title)
                                         }
                                         ElapsedTimeView(elapsedTime: trainingManager.builder?.elapsedTime(at: context.date) ?? 0)
                                             .foregroundStyle(.yellow)
                                     }
                                     .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                     .frame(maxWidth: .infinity, alignment: .leading)
                                     .ignoresSafeArea(edges: .bottom)
                                     .scenePadding()
                                 }
    }
}

struct TrainingInfo_Previews: PreviewProvider {
    static var previews: some View {
        TrainingInfo()
    }
}

private struct InfoTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool

    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate, by: 1.0)
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
}
