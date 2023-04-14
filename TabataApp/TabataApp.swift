//
//  TabataAppApp.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 11.03.2023.
//

import SwiftUI
import Models

@main
struct TabataApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(model: AppModel(path: [], trainingsList: TrainingsListModel()))
        }
    }
}
