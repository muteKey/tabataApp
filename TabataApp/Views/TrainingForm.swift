//
//  AddTraining.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 12.03.2023.
//

import SwiftUI

struct TrainingForm: View {
    @ObservedObject var model: TrainingFormModel
    var onSave: (Training) -> Void
    var body: some View {
        VStack {
            List {
                FormEntryField(model.validateTrainingTitle()) {
                    TextField(L10n.trainingName, text: self.$model.training.title)
                        .formFieldStyle()                    
                }
                
                FormEntryField(model.validateBreakBetweenLaps()) {
                    Stepper("\(L10n.breakBetweenLaps) \(formatDuration(self.model.training.breakBetweenLaps))", value: self.$model.training.breakBetweenLaps, in: self.model.breakBetweenLapsRange)
                }
                
                ForEach(self.$model.training.laps) { $lap in
                    if lap.phases.count > 0 {
                        Section {
                            ForEach($lap.phases) { phase in
                                VStack {
                                    FormEntryField(model.validatePhaseTitle(phase.title.wrappedValue)) { 
                                        HStack {
                                            TextField(L10n.phaseTitle, text: phase.title)
                                                .formFieldStyle()
                                            
                                            Button(role: .destructive) {
                                                hideKeyboard()
                                                self.model.removePhase(phase.wrappedValue, from: lap)
                                            } label: {
                                                Image(systemName: "minus.circle.fill")
                                            }
                                        }
                                    }
                                    FormEntryField(model.validatePhaseWorkDuration(phase.workDuration.wrappedValue)) {
                                        Stepper("\(L10n.workDuration) \(formatDuration(phase.wrappedValue.workDuration))", value: phase.workDuration, in: self.model.workDurationRange)
                                    }
                                    
                                    FormEntryField(model.validatePhaseBreakDuration(phase.wrappedValue.breakDuration)) {
                                        Stepper("\(L10n.breakDuration) \(formatDuration(phase.wrappedValue.breakDuration))", value: phase.breakDuration, in: self.model.breakDurationRange)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        } header: {
                            Text(self.model.sectionTitle(for: lap))
                        } footer: {
                            Button {
                                self.model.addPhase(for: lap)
                            } label: {
                                Text(L10n.addPhase)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            Button {
                self.model.addLap()
            } label: {
                Label(L10n.addLap, systemImage: "plus.app.fill")
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(L10n.save) {
                    self.onSave(model.training)
                }
                .disabled(!model.training.isValid)
            }
        }
    }
}

struct FormTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled(true)
            .keyboardType(.alphabet)
            .submitLabel(.done)
    }
}

struct FormEntryField<Content: View>: View {
    let validationState: ValidatedFieldState
    let inputField: Content
    
    init(_ validationState: ValidatedFieldState, @ViewBuilder _ inputField: () -> Content) {
        self.inputField = inputField()
        self.validationState = validationState
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            inputField
            if case let .invalid(text) = validationState {
                Text(text)
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
        
    }
}

struct TrainingForm_Previews: PreviewProvider {
    static var previews: some View {
        TrainingForm(model: TrainingFormModel(training: .mock), onSave: {_ in })
    }
}
