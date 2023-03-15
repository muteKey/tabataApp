//
//  TrainingLaunch.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 13.03.2023.
//

import SwiftUI
import Combine
import AVFoundation

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
            Text("Total training progress")
            ProgressView(value: Double(self.totalTimeRemaining), total: Double(self.model.phasesModel.totalDuration))
            HStack(alignment: .center) {
                Button {
                    model.onStop()
                    timerModel.stopTimer()
                } label: {
                    Label("Stop", systemImage: "stop.fill")
                }
                
                Spacer()
                if timerModel.state == .running {
                    Button {
                        self.timerModel.pauseTimer()
                    } label: {
                        Label("Pause", systemImage: "pause.fill")
                    }
                } else if timerModel.state == .paused {
                    Button {
                        self.timerModel.resumeTimer()
                    } label: {
                        Label("Resume", systemImage: "play.fill")
                    }
                }
            }
            .padding()
            Spacer()
            ZStack {
                CircularProgressView(progress: self.phaseProgress, tintColor: self.model.phasesModel.color)
                    .frame(width: 250, height: 250)
                    .padding()
                Text(self.model.phasesModel.currentPhaseTitle)
                    .font(.headline)
                    .padding(30)
            }
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("Time Left:")
                        .font(.caption)
                    Label("\(formatDuration(self.phaseTimeRemaining))", systemImage: "hourglass.bottomhalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Phase Duration:")
                        .font(.caption)
                    Label("\(formatDuration(self.model.phasesModel.currentDuration))", systemImage: "hourglass.tophalf.fill")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(model.training.title)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .onReceive(timerModel.timerPublisher) { _ in
            guard totalTimeRemaining < model.phasesModel.totalDuration else {
                self.isTrainingFinished = true
                timerModel.stopTimer()
                return
            }
            
            if phaseTimeRemaining > 0 {
                phaseTimeRemaining -= 1
            } else {
                self.model.phasesModel.updatePhase()
//                playSound()
                phaseTimeRemaining = self.model.phasesModel.currentDuration
            }
            
            self.totalTimeRemaining += 1
        }
        .alert("Training Finished", isPresented: $isTrainingFinished) {
            Button("OK", role: .cancel) {
                model.onFinish()
            }
        }
    }
    
    func playSound() {
        player.seek(to: .zero)
        player.play()
    }
}

struct TrainingLaunch_Previews: PreviewProvider {
    static var previews: some View {
        TrainingLaunch(model: TrainingLaunchModel(training:
                                                    Training(title: "First Training",
                                                             laps: [
                                                                Training.Lap(breakDuration: 30, workDuration: 15)
                                                             ],
                                                                     breakBetweenLaps: 10)))
    }
}
