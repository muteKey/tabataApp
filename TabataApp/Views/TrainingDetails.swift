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
                Label("\(L10n.totalDuration): \(formatDuration(model.training.totalDuration))", systemImage: "clock.circle")
                Label("\(L10n.numberOfLaps): \(model.training.laps.count)", systemImage: "figure.run")
                Label("\(L10n.breakBetweenLaps): \(formatDuration(model.training.breakBetweenLaps))", systemImage: "bed.double")
            }
            NavigationLink(value: AppModel.Destination.launch(TrainingLaunchModel(training: model.training))) {
                Label(L10n.launch, systemImage: "play.fill")
            }
        }
        .navigationTitle(model.training.title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    self.model.editTapped()
                } label: {
                    Label(L10n.editTraining, systemImage: "pencil")
                }
            }
        }
        .sheet(unwrapping: self.$model.destination,
               case: /TrainingDetailModel.Destination.edit) { $formModel in
            NavigationStack {
                TrainingForm(model: formModel)
                    .navigationTitle(L10n.editTraining)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(L10n.save) {
                                self.model.saveTapped(formModel.training)
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button(L10n.cancel) {
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
 
