//
//  WatchOSTabataApp.swift
//  WatchOSTabata Watch App
//
//  Created by Kirill Ushkov on 14.04.2023.
//

import SwiftUI
import Models

@main
struct WatchTabataApp: App {
    @StateObject var trainingManager = TrainingManager()
    var body: some Scene {
        WindowGroup {
            AppView(model: AppModel(path: [], trainingsList: 
                                        TrainingsListModel(dataManager: .forPreview)))
            .environmentObject(trainingManager)
        }
    }
}
