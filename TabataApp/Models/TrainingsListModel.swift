import Foundation
import SwiftUI

final class TrainingsListModel: ObservableObject {
    @Published var trainings: [Training]
    
    init(trainings: [Training]) {
        self.trainings = trainings
    }
        
    func addTraining(_ training: Training) {
        self.trainings.append(training)
    }
    
    func removeTraining(at indexSet: IndexSet) {
        self.trainings.remove(atOffsets: indexSet)
    }
    
    func bindingFor(_ trainingId: Training.ID) -> Binding<Training> {
        return Binding {
            self.trainings.first { $0.id == trainingId }!
        } set: { newValue in
            guard let index = self.trainings.firstIndex(where: { $0.id == trainingId }) else {
                fatalError()
            }
            self.trainings[index] = newValue
        }
    }
    
    func training(for id: Training.ID) -> Training {
        guard let index = self.trainings.firstIndex(where: { $0.id == id }) else { fatalError() }
        return self.trainings[index]
    }
}

extension TrainingsListModel {
    static var mock: TrainingsListModel {
        TrainingsListModel(trainings: [
            Training(title: "First Training", laps: [], breakBetweenLaps: 0)
        ])
    }
}
