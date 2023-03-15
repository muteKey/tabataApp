import Foundation
import SwiftUI

final class TrainingsListModel: ObservableObject {
    @Published var trainings: [Training]
    @Published var destination: Destination?
    
    enum Destination {
        case add(TrainingFormModel)
    }
            
    init(trainings: [Training], destination: Destination? = nil) {
        self.trainings = trainings
        self.destination = destination
    }
    
    func addTraining(_ training: Training) {
        self.trainings.append(training)
    }
    
    func removeTraining(at indexSet: IndexSet) {
        self.trainings.remove(atOffsets: indexSet)
    }
    
    func addTrainingTapped() {
        self.destination = .add(TrainingFormModel(training: Training(title: "", laps: [], breakBetweenLaps: 0)))
    }
    
    func saveTapped(_ training: Training) {
        addTraining(training)
        self.destination = nil
    }
}

extension TrainingsListModel {
    static var mock: TrainingsListModel {
        TrainingsListModel(trainings: [
            .mock
        ])
    }
}
