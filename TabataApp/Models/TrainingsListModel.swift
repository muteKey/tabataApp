import Foundation
import SwiftUI

final class TrainingsListModel: ObservableObject {
    @Published var trainings: [Training]
    @Published var destination: Destination?
    
    private var dataManager: DataManager
    
    enum Destination {
        case add(TrainingFormModel)
    }
            
    init(destination: Destination? = nil, dataManager: DataManager = DataManager()) {
        self.destination = destination
        self.dataManager = dataManager
        
        do {
            let data = try dataManager.loadData(from: .trainings)
            self.trainings = try JSONDecoder().decode([Training].self, from: data)
        } catch {
            self.trainings = []
        }
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
    
    func save() throws {
        let data = try JSONEncoder().encode(self.trainings)
        try dataManager.saveData(data: data)
    }
}

extension TrainingsListModel {
    static var mock: TrainingsListModel {
        TrainingsListModel()
    }
}
