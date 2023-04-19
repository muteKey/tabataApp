//
//  TrainingLaunch.swift
//  WatchTabata
//
//  Created by Kirill Ushkov on 15.04.2023.
//

import SwiftUI
import Models
import UIKit
import HealthKit

struct TrainingLaunch: View {
    enum Tab {
        case info, controls, metrics
    }
    @State private var selection: Tab = .info
    
    @EnvironmentObject var trainingManager: TrainingManager
    @Environment(\.scenePhase) var scenePhase
    
    var model: TrainingLaunchModel
    @ObservedObject var timerModel: TimerModel
    
    @State private var phaseTimeRemaining: Int = 0
    @State private var totalTimeRemaining: Int = 0
    @State private var isTrainingFinished: Bool = false
    
    
    init(model: TrainingLaunchModel) {
        self.model = model
        self.timerModel = TimerModel()
        self.phaseTimeRemaining = self.model.phasesModel.currentDuration
    }
    
    var body: some View {
        TabView(selection: $selection) {
            TrainingInfo()
                .tag(Tab.info)
            TrainingControls(onPause: pause, onResume: resume, onStop: stop, isSessionRunning: $trainingManager.isSessionRunning)
                .tag(Tab.controls)
            TrainingMetrics(heartRate: $trainingManager.heartRate,
                            distance: $trainingManager.distance,
                            energy: $trainingManager.activeEnergy)
            .tag(Tab.metrics)
        }
        .onAppear {
            trainingManager.startTraining(with: model.phasesModel)
        }
        .navigationTitle(model.training.title)
        .navigationBarBackButtonHidden(true)
//        .onReceive(timerModel.timerPublisher) { _ in
//            print("on receive timer")
//            guard scenePhase == .active else { return }
//            guard totalTimeRemaining < model.phasesModel.totalDuration else {
//                self.isTrainingFinished = true
//                timerModel.stopTimer()
//                return
//            }
//            
//            if phaseTimeRemaining > 0 {
//                phaseTimeRemaining -= 1
//                totalTimeRemaining += 1
//            } else {
//                self.model.phasesModel.updatePhase()
//                playSound()
//                hapticFeedback()
//                phaseTimeRemaining = self.model.phasesModel.currentDuration
//                trainingManager.startNewActivity()
//            }
//        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                let interval = timerModel.onActive()
                phaseTimeRemaining -= interval
                totalTimeRemaining += interval
            } else if newPhase == .inactive {
                
            } else if newPhase == .background {
                timerModel.onBackground()
            }
        }

    }
    
    func stop() {
        trainingManager.stopTraining()
    }
    
    func resume() {
        trainingManager.resumeTraining()
    }
    
    func pause() {
        trainingManager.pauseTraining()
    }
}

struct TrainingLaunch_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TrainingLaunch(model: .forPreview)
        }.environmentObject(TrainingManager())
    }
}
