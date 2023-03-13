//
//  TrainingsList.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 11.03.2023.
//

import SwiftUI

struct TrainingsList: View {
    @ObservedObject var model: TrainingsListModel
    @State private var isShowingAddDialog = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(self.model.trainings) { training in
                    NavigationLink(value: training.id) {
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
            .navigationDestination(for: Training.ID.self) { trainingId in
//                TrainingDetails(model: TrainingDetailModel(training: model.bindingFor(trainingId)))
                TrainingLaunch(model: TrainingLaunchModel(training: self.model.training(for: trainingId)))
            }
            .sheet(isPresented: self.$isShowingAddDialog) {
                AddTraining(model: self.model, isPresented: self.$isShowingAddDialog)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Add Training") {
                        self.isShowingAddDialog.toggle()
                    }
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
        TrainingsList(model: .mock)
    }
}
