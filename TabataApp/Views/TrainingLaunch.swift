//
//  TrainingLaunch.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 13.03.2023.
//

import SwiftUI
import Combine
import AVFoundation
import Models

struct TrainingLaunch: View {
    @State private var phaseTimeRemaining: Int
    @State private var totalTimeRemaining: Int
    @State private var isTrainingFinished: Bool = false
    
    @ObservedObject var timerModel: TimerModel
    
    var model: TrainingLaunchModel
    
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    init(model: TrainingLaunchModel) {
        self.model = model
        self.phaseTimeRemaining = self.model.phasesModel.currentDuration
        self.totalTimeRemaining = 0
        self.timerModel = TimerModel()
    }
        
    private var phaseProgress: Double {
        return 1 - (Double(self.phaseTimeRemaining) / Double(self.model.phasesModel.currentDuration))
    }
        
    var body: some View {
        VStack {
            Text(L10n.totalTraining)
            ProgressView(value: Double(self.totalTimeRemaining), total: Double(self.model.phasesModel.totalDuration))                
            .padding()
            ZStack {
                CircularProgressView(progress: self.phaseProgress, tintColor: self.model.phasesModel.color)
                    .padding()
                VStack {
                    Text(self.model.phasesModel.currentPhaseTitle)
                        .font(.headline)
                        .padding(30)
                    if timerModel.state == .running {
                        Button {
                            self.timerModel.pauseTimer()
                        } label: {
                            Image(systemName: "pause.fill")
                                .resizable()
                                .frame(width: 80, height:80)
                        }
                        .buttonStyle(.plain)
                        .tint(.black)
                    } else if timerModel.state == .paused {
                        Button {
                            self.timerModel.resumeTimer()
                        } label: {
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 80, height:80)

                        }
                        .buttonStyle(.plain)
                        .tint(.black)
                    }
                }
            }
            Spacer()
            Button {
                self.timerModel.pauseTimer()
                self.totalTimeRemaining += self.phaseTimeRemaining
                self.model.phasesModel.updatePhase()
                phaseTimeRemaining = self.model.phasesModel.currentDuration
                self.timerModel.resumeTimer()
            } label: {
                Label(L10n.skip, systemImage: "forward.fill")
            }
            .buttonStyle(.plain)
            .tint(.black)

            Spacer()

            HStack {
                VStack(alignment: .leading) {
                    Text("\(L10n.timeLeft):")
                        .font(.caption)
                    Label("\(formatDuration(self.phaseTimeRemaining))", systemImage: "hourglass.bottomhalf.fill")
                }
                Spacer()
                Button {
                    model.onStop()
                    timerModel.stopTimer()
                } label: {
                    Label(L10n.stop, systemImage: "stop.fill")
                }
                .buttonStyle(.plain)
                .tint(.black)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(L10n.phaseDuration):")
                        .font(.caption)
                    Label("\(formatDuration(self.model.phasesModel.currentDuration))", systemImage: "hourglass.tophalf.fill")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(model.training.title)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
        .onReceive(timerModel.timerPublisher) { _ in
            guard totalTimeRemaining < model.phasesModel.totalDuration else {
                self.isTrainingFinished = true
                timerModel.stopTimer()
                return
            }
            
            if phaseTimeRemaining > 0 {
                phaseTimeRemaining -= 1
                totalTimeRemaining += 1
            } else {
                self.model.phasesModel.updatePhase()
                playSound()
                hapticFeedback()
                phaseTimeRemaining = self.model.phasesModel.currentDuration
            }
        }
        .alert(L10n.trainingFinished, isPresented: $isTrainingFinished) {
            Button("OK", role: .cancel) {
                model.onFinish()
            }
        }
    }
    
    func playSound() {
        player.seek(to: .zero)
        player.play()
    }
    
    func hapticFeedback() {
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
        impactMed.impactOccurred()
    }
}

extension TrainingPhasesModel {
    public var currentPhaseTitle: String {
        guard self.phases.count > 0 else { return "" }
        switch self.phases[self.currentIndex] {
        case .breakBetweenLaps:
            return L10n.breakBetweenLaps
        case let .lapWork(index, _, title):
            return "\(L10n.lap) \(index): \(title)"
        case let .lapBreak(index, _):
            return "\(L10n.lap) \(index): \(L10n.break)!"
        }
    }
}

extension TrainingLaunchModel {
    static var forPreview: TrainingLaunchModel {
        TrainingLaunchModel(training:
                                Training(title: "First Training",
                                         laps: [
                                            Training.Lap(phases: [
                                                Training.Phase(breakDuration: 5, workDuration: 60, title: "Section 0"),
                                                Training.Phase(breakDuration: 5, workDuration: 60, title: "Section 0")
                                            ]),
                                            Training.Lap(phases: [
                                                Training.Phase(breakDuration: 5, workDuration: 60, title: "Section 1"),
                                                Training.Phase(breakDuration: 5, workDuration: 60, title: "Section 1")
                                            ])
                                         ],
                                         breakBetweenLaps: 60))
    }
}


struct TrainingLaunch_Previews: PreviewProvider {
    static var previews: some View {
        TrainingLaunch(model: .forPreview)
    }
}
