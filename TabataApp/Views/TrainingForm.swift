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
                
                FormTimeEntryField(model.validateBreakBetweenLaps(),
                                   hint: "\(L10n.breakBetweenLaps) \(formatDuration(self.model.training.breakBetweenLaps))",
                                   {
                        TimePicker(selection: self.$model.training.breakBetweenLaps)
                })
                
                ForEach(self.$model.training.laps) { $lap in
                    if lap.phases.count > 0 {
                        Section {
                            ForEach($lap.phases) { phase in
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
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(4)
                                    FormTimeEntryField(model.validatePhaseWorkDuration(phase.workDuration.wrappedValue),
                                                                                       hint: "\(L10n.workDuration) \(formatDuration(phase.wrappedValue.workDuration))",
                                                                                       {
                                        TimePicker(selection: phase.workDuration)
                                    })
                                    .padding(4)
                                    
                                    FormTimeEntryField(model.validatePhaseBreakDuration(phase.wrappedValue.breakDuration),
                                                       hint: "\(L10n.breakDuration) \(formatDuration(phase.wrappedValue.breakDuration))") {
                                        TimePicker(selection: phase.breakDuration)
                                    }
                                    .padding(4)
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
            .padding(8)
            Button {
                self.model.addLap()
            } label: {
                Label(L10n.addLap, systemImage: "plus.app.fill")
            }
            .padding()
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

struct FormTimeEntryField<Content: View>: View {
    let validationState: ValidatedFieldState
    let hint: String
    let timeField: Content
    @State private var isExpanded = false
    
    init(_ validationState: ValidatedFieldState, hint: String, @ViewBuilder _ timeField: () -> Content) {
        self.timeField = timeField()
        self.validationState = validationState
        self.hint = hint
    }

    
    var body: some View {
        Button {
            isExpanded.toggle()
        } label: {
            VStack(alignment: .leading) {
                Text(hint)
                if case let .invalid(text) = validationState {
                    Text(text)
                        .font(.caption2)
                        .foregroundColor(.red)
                }
                if isExpanded {
                    timeField
                }
            }
        }
        .buttonStyle(.automatic)
    }
}

struct TrainingForm_Previews: PreviewProvider {
    static var previews: some View {
        TrainingForm(model: TrainingFormModel(training: .mock), onSave: {_ in })
    }
}
