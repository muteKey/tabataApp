//
//  TrainingManager.swift
//  WatchTabata
//
//  Created by Kirill Ushkov on 17.04.2023.
//

import Foundation
import HealthKit
import Combine
import SwiftUI
import Models

struct Activity {
    let configuration: HKWorkoutConfiguration
    let metadata: [String: Any]
}

class TrainingManager: NSObject, ObservableObject {
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    
    @Published var isSessionRunning = false
    
    var intervalTimeLine: IntervalTimeline?
    
    func startTraining(with phaseModel: TrainingPhasesModel) {
        let config = HKWorkoutConfiguration()
        config.activityType = .highIntensityIntervalTraining
        config.locationType = .unknown

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }
        
        session?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)
        
        let startDate = Date()
        intervalTimeLine = IntervalTimeline(startDate: startDate, phases: phaseModel.phases)
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate, completion: { success, error in
            print("beginCollection")
            print(success)
            print(error)
        })
    }
    
//    func intervalActivities(at startDate: Date, for phases: [TrainingPhasesModel.Phase]) {
//        var latestDate = startDate
//        for phase in phases {
//            let config = HKWorkoutConfiguration()
//            config.activityType = .highIntensityIntervalTraining
//            config.locationType = .unknown
//
//            let activity = HKWorkoutActivity(workoutConfiguration: config,
//                                             start: latestDate,
//                                             end: nil,
//                                             metadata: phase.metadata)
//            activities.append(activity)
//            latestDate = latestDate.addingTimeInterval(phase.duration)
//        }
//    }
    
    func isAuthorised() -> Bool {
        if healthStore.authorizationStatus(for: .workoutType()) == .notDetermined ||
            healthStore.authorizationStatus(for: .workoutType()) == .sharingDenied {
            return false
        }
        return true
    }
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let typesToWrite = Set([
            HKQuantityType.workoutType()
        ])
        let typesToRead = Set([
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.activitySummaryType()
        ])
        
        healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead) { success, error in
            print("requestAuthorization result \(success)")
        }
    }
    
    func pauseTraining() {
        togglePause()
        intervalTimeLine?.pause()
    }
    
    func togglePause() {
        if isSessionRunning {
            session?.pause()
        } else {
            resumeTraining()
        }
    }
    
    func resumeTraining() {
        session?.resume()
        intervalTimeLine?.resume()
    }
    
    func stopTraining() {
        session?.end()
    }
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }
    
}

extension TrainingPhasesModel.Phase {
//    var metadata: [String: Any] {
//        switch self {
//        case .breakBetweenLaps:
//            return ["type": TrainingManager.IntervalType.cooldown.rawValue, "title": L10n.breakBetweenLaps]
//        case let .lapWork(lapNumber, _, title):
//            return ["type": TrainingManager.IntervalType.work.rawValue, "title": title, "lapNumber": lapNumber]
//        case .lapBreak(let lapNumber, _):
//            return ["type": TrainingManager.IntervalType.rest.rawValue, "lapNumber": lapNumber, "title": L10n.break]
//        }
//    }
//
    var title: String {
        switch self {
        case .breakBetweenLaps:
            return L10n.breakBetweenLaps
        case let .lapWork(_,_, title):
            return title
        case .lapBreak:
            return L10n.break
        }
    }
}

//extension HKWorkoutActivity {
//    var title: String? {
//        guard let title = self.metadata?["title"] as? String else {
//            return nil
//        }
//        return title
//    }
//}

extension TrainingManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("didFailWithError")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        DispatchQueue.main.async {
            self.isSessionRunning = toState == .running
        }
        
        if toState == .ended {
            builder?.endCollection(withEnd: date, completion: { [weak self] success, error in
                self?.builder?.finishWorkout(completion: { workout, error in
                    print("workoutSession didChangeTo")
                })
            })
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didBeginActivityWith workoutConfiguration: HKWorkoutConfiguration, date: Date) {
        print("workoutSession didBeginActivityWith")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didEndActivityWith workoutConfiguration: HKWorkoutConfiguration, date: Date) {
        print("workoutSession didEndActivityWith")
    }
}

extension TrainingManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }

            let statistics = workoutBuilder.statistics(for: quantityType)
            updateForStatistics(statistics)
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        print("workoutBuilderDidCollectEvent")
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didBegin workoutActivity: HKWorkoutActivity) {
        print("workoutBuilder didBegin workoutActivity")
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didEnd workoutActivity: HKWorkoutActivity) {
        print("didEnd workoutActivity")
//        print(workoutActivity)
//        if activities.isEmpty {
//            stopTraining()
//        }
//        
//        let activity = activities.removeFirst()
//        builder?.addWorkoutActivity(activity, completion: { isSuccess, error in
//            self.session?.startActivity(with: nil)
//        })
    }
}
