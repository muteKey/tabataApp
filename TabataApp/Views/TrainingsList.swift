//
//  TrainingsList.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 11.03.2023.
//

import SwiftUI
import SwiftUINavigation

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
        .navigationTitle("My Trainings")
        .sheet(unwrapping: self.$model.destination,
               case: /TrainingsListModel.Destination.add,
               content: { $formModel in
            NavigationStack {
                TrainingForm(model: formModel)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Save") {
                            self.model.saveTapped(formModel.training)
                        }
                    }
                }
                .navigationTitle("Add New Training")
            }
        })
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    self.model.addTrainingTapped()
                } label: {
                    Label("Add Training", systemImage: "plus")
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
            Text("Number of laps: \(self.training.laps.count)")
            Text("Total duration: \(formatDuration(self.training.totalDuration))")
        }

    }
}


struct TrainingsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TrainingsList(model: .mock)
        }
        
    }
}
