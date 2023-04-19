//
//  TrainingDetails.swift
//  WatchTabata
//
//  Created by Kirill Ushkov on 15.04.2023.
//

import SwiftUI
import Models

struct TrainingDetails: View {
    @ObservedObject var model: TrainingDetailModel
    
    var body: some View {
        VStack {
            List {
                Label("\(L10n.totalDuration): \(formatDuration(model.training.totalDuration))", systemImage: "clock.circle")
                Label("\(L10n.sets): \(model.training.laps.count)", systemImage: "figure.run")
                Label("\(L10n.breakBetweenLaps): \(formatDuration(model.training.breakBetweenLaps))", systemImage: "bed.double")
            }
            NavigationLink(value: AppModel.Destination.launch(TrainingLaunchModel(training: model.training))) {
                Image(systemName: "play.fill")
            }
        }
        .navigationTitle(model.training.title)
    }
}

struct TrainingDetails_Previews: PreviewProvider {
    struct Wrapper: View {
        var body: some View {
            TrainingDetails(model: TrainingDetailModel(training: .forPreview))
        }
    }

    static var previews: some View {
        NavigationStack {
            Wrapper()
        }
    }
}
