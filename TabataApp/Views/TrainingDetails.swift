//
//  TrainingDetails.swift
//  TabataApp
//

import SwiftUI

struct TrainingDetails: View {
    @ObservedObject var model: TrainingDetailModel
    
    var body: some View {
        VStack {
            Form {
                TextField("Training Name", text: self.model.training.title)
                Stepper("Break Between Laps", value: self.model.training.breakBetweenLaps)
                ForEach(self.model.training.laps) { $lap in
                    Section {
                        Stepper("Work Duration \(formatDuration(lap.workDuration))", value: $lap.workDuration)
                        Stepper("Break Duration \(formatDuration(lap.breakDuration))", value: $lap.breakDuration)
                        Button("Remove Lap", role: .destructive) {
                            self.model.removeLap(lap)
                        }
                    }
                }
            }
            
            Button {
                self.model.addLap()
            } label: {
                Label("Add Lap", systemImage: "plus.app.fill")
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink(value: TrainingDetailModel.Destination.launchTraining) {
                    Label("Launch", systemImage: "plus")
                }
            }
        }
        .navigationDestination(for: TrainingDetailModel.Destination.self, destination: { route in
            switch route {
            case .launchTraining:
                TrainingLaunch(model: TrainingLaunchModel(training: self.model.training.wrappedValue))
            }
        })

        .navigationTitle(self.model.training.title)
    }
}

func formatDuration(_ duration: Int) -> String {
    return Duration.seconds(duration).formatted()
}

//struct TrainingDetails_Previews: PreviewProvider {
//    struct Wrapper: View {
//
//        var body: some View {
//            NavigationView {
//                TrainingDetails(model: TrainingDetailModel(training: .init(title: "Test Training", laps: [])))
//            }
//        }
//    }
//    static var previews: some View {
//        Wrapper()
//    }
//}
