//
//  AppView.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 14.03.2023.
//

import SwiftUI
import Combine

struct AppView: View {
    @ObservedObject var model: AppModel
    
    var body: some View {
        NavigationStack(path: self.$model.path) {
            TrainingsList(model: self.model.trainingsList)
            .navigationDestination(for: AppModel.Destination.self) { route in
                switch route {
                case let .launch(model):
                    TrainingLaunch(model: model)
                case let .detail(model):
                    TrainingDetails(model: model)
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(model: AppModel(path: [], trainingsList: TrainingsListModel()))
    }
}
