//
//  TrainingDetails.swift
//  TabataApp
//

import SwiftUI
import SwiftUINavigation

struct TrainingDetails: View {
    @ObservedObject var model: TrainingDetailModel
    
    var body: some View {
        VStack {
            List {
                Label("Total duration: \(formatDuration(model.training.totalDuration))", systemImage: "clock.circle")
                Label("Number of laps: \(model.training.laps.count)", systemImage: "figure.run")
                Label("Break between laps: \(formatDuration(model.training.breakBetweenLaps))", systemImage: "bed.double")
            }
            NavigationLink(value: AppModel.Destination.launch(TrainingLaunchModel(training: model.training))) {
                Label("Launch", systemImage: "play.fill")
            }
        }
        .navigationTitle(model.training.title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    self.model.editTapped()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
        .sheet(unwrapping: self.$model.destination,
               case: /TrainingDetailModel.Destination.edit) { $formModel in
            NavigationStack {
                TrainingForm(model: formModel)
                    .navigationTitle("Edit Training")
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Button("Save") {
                                self.model.saveTapped(formModel.training)
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                self.model.cancelEditingTapped()
                            }
                        }
                    }

            }
        }
    }
}

func formatDuration(_ duration: Int) -> String {
    return Duration.seconds(duration).formatted()
}

struct TrainingDetails_Previews: PreviewProvider {
    struct Wrapper: View {

        var body: some View {
            TrainingDetails(model: TrainingDetailModel(training: .mock))
        }
    }
    static var previews: some View {
        Wrapper()
    }
}
 
