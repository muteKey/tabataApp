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
            List {
                TextField("Training Name", text: self.$model.training.title)
                    .autocorrectionDisabled(true)
                    .keyboardType(.alphabet)

                Stepper("Break Between Laps \(formatDuration(self.model.training.breakBetweenLaps))", value: self.$model.training.breakBetweenLaps)
                
                ForEach(self.$model.training.laps) { $lap in
                    if lap.phases.count > 0 {
                        Section {
                            ForEach($lap.phases) { phase in
                                VStack {
                                    HStack {
                                        TextField("Phase Title", text: phase.title)
                                            .autocorrectionDisabled(true)
                                            .keyboardType(.alphabet)
                                        
                                        Button(role: .destructive) {
                                            hideKeyboard()
                                            self.model.removePhase(phase.wrappedValue, from: lap)
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                        }
                                    }
                                    Stepper("Work Duration \(formatDuration(phase.wrappedValue.workDuration))", value: phase.workDuration)
                                    Stepper("Break Duration \(formatDuration(phase.wrappedValue.breakDuration))", value: phase.breakDuration)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        } header: {
                            Text(self.model.sectionTitle(for: lap))
                        } footer: {
                            Button {
                                self.model.addPhase(for: lap)
                            } label: {
                                Text("Add Phase")
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            Button {
                self.model.addLap()
            } label: {
                Label("Add Lap", systemImage: "plus.app.fill")
            }
        }
    }
}

struct PhaseView: View {
    let lap: Training.Lap
    var phase: Binding<Training.Phase>
    
    var body: some View {
        VStack {
            HStack {
                TextField("Phase Title", text: phase.title)
                    .autocorrectionDisabled(true)
                    .keyboardType(.alphabet)
                    
                Button(role: .destructive) {
//                    self.model.removePhase(phase.wrappedValue, from: lap)
                } label: {
                    Image(systemName: "minus.circle.fill")
                }
            }
            Stepper("Work Duration \(formatDuration(phase.wrappedValue.workDuration))", value: phase.workDuration)
            Stepper("Break Duration \(formatDuration(phase.wrappedValue.breakDuration))", value: phase.breakDuration)
        }
    }
}

struct TrainingForm_Previews: PreviewProvider {
    static var previews: some View {
        TrainingForm(model: TrainingFormModel(training: .mock))
    }
}
