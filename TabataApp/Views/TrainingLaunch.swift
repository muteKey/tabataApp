//
//  TrainingLaunch.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 13.03.2023.
//

import SwiftUI
import Combine

struct TrainingLaunch: View {
    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var phaseTimeRemaining: Int
    @State private var totalTimeRemaining: Int
    @State private var isTrainingFinished: Bool = false
    
    init(model: TrainingLaunchModel) {
        self.model = model
        self.phaseTimeRemaining = self.model.currentDuration
        self.totalTimeRemaining = 0
    }
    
    var model: TrainingLaunchModel
    
    var body: some View {
        VStack {
            Text("Total training progress")
            ProgressView(value: Double(self.totalTimeRemaining), total: Double(self.model.totalDuration))
            Circle()
                .strokeBorder(lineWidth: 24)
            HStack {
                VStack(alignment: .leading) {
                    Text("Time Elapsed:")
                        .font(.caption)
                    Label("\(formatDuration(self.phaseTimeRemaining))", systemImage: "hourglass.bottomhalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Time Remaining:")
                        .font(.caption)
                    Label("\(formatDuration(self.model.currentDuration))", systemImage: "hourglass.tophalf.fill")
                }
            }
            HStack {
                Text(self.model.currentPhaseTitle)
            }
        }
        .padding()
        .onReceive(countdownTimer) { _ in
            guard totalTimeRemaining < model.totalDuration else {
                self.isTrainingFinished = true
                return
            }
            if phaseTimeRemaining > 0 {
                phaseTimeRemaining -= 1
            } else {
                self.model.updatePhase()
                phaseTimeRemaining = self.model.currentDuration
            }
            
            self.totalTimeRemaining += 1
        }
        .alert("Training Finished", isPresented: $isTrainingFinished) {
            Button("OK", role: .cancel) { }
        }
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
