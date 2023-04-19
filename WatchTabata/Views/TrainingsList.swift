//
//  TrainingsList.swift
//  WatchTabata
//
//  Created by Kirill Ushkov on 15.04.2023.
//

import SwiftUI
import Models

struct TrainingsList: View {
    @ObservedObject var model: TrainingsListModel
    @EnvironmentObject var trainingManager: TrainingManager

    var body: some View {
        List {
            ForEach(self.model.trainings) { training in
                NavigationLink(value: AppModel.Destination.detail(TrainingDetailModel(training: training))) {
                    Text(training.title)
                }
            }
        }
        .listStyle(.carousel)
        .navigationTitle(L10n.myTrainings)
        .onAppear {
            trainingManager.requestAuthorization()
        }
    }
}

struct TrainingsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TrainingsList(model: .forPreview)
        }
        .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 8 (41mm)"))
        .previewDisplayName("Apple Watch")
    }
}
