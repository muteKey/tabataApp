//
//  AddTraining.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 12.03.2023.
//

import SwiftUI

struct TrainingForm: View {
    @ObservedObject var model: TrainingFormModel
    
    var body: some View {
        VStack {
            Form {
                TextField("Training Name", text: self.$model.training.title)
                Stepper("Break Between Laps \(formatDuration(self.model.training.breakBetweenLaps))", value: self.$model.training.breakBetweenLaps)
                ForEach(self.$model.training.laps) { $lap in
                    Section {
                        Stepper("Work Duration \(formatDuration(lap.workDuration))", value: $lap.workDuration)
                        Stepper("Break Duration \(formatDuration(lap.breakDuration))", value: $lap.breakDuration)
                        Button("Remove Lap", role: .destructive) {
                            self.model.removeLap(lap)
                        }
                    }
                }
                Button {
                    self.model.addLap()
                } label: {
                    Label("Add Lap", systemImage: "plus.app.fill")
                }
            }            
        }
    }
}

struct AddTraining_Previews: PreviewProvider {
    static var previews: some View {
        TrainingForm(model: TrainingFormModel(training: .mock))
    }
}
