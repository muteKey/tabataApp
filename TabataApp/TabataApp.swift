//
//  TabataAppApp.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 11.03.2023.
//

import SwiftUI

@main
struct TabataApp: App {
    var body: some Scene {
        WindowGroup {
            TrainingsList(model: .init(trainings: [
                Training(title: "First Training",
                         laps: [
                            Training.Lap(breakDuration: 60, workDuration: 30),
                            Training.Lap(breakDuration: 30, workDuration: 15)
                         ],
                         breakBetweenLaps: 10)
            ]))
        }
    }
}
