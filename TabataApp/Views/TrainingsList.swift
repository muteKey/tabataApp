//
//  TrainingsList.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 11.03.2023.
//

import SwiftUI
import SwiftUINavigation
import Models

struct TrainingsList: View {
    @ObservedObject var model: TrainingsListModel
    
    var body: some View {
        List {
            ForEach(self.model.trainings) { training in
                NavigationLink(value: AppModel.Destination.detail(TrainingDetailModel(training: training))) {
                    TrainingRowItem(training: training)
                }
            }
            .onDelete { indexset in
                withAnimation {
                    self.model.removeTraining(at: indexset)
                }
            }
        }
        .navigationTitle(L10n.myTrainings)
        .sheet(unwrapping: self.$model.destination,
               case: /TrainingsListModel.Destination.add,
               content: { $formModel in
            NavigationStack {
                TrainingForm(model: formModel, onSave: { training in
                    self.model.saveTapped(training)
                })
                .navigationTitle(L10n.addNewTraining)
            }
        })
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    self.model.addTrainingTapped()
                } label: {
                    Label(L10n.addTraining, systemImage: "plus")
                }
            }
        }
    }
}

struct TrainingRowItem: View {
    let training: Training
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.training.title)
            Text("\(L10n.numberOfLaps): \(self.training.laps.count)")
            Text("\(L10n.totalDuration): \(formatDuration(self.training.totalDuration))")
        }
    }
}

struct TrainingsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TrainingsList(model: .forPreview)
        }
    }
}
