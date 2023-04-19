import Foundation
import SwiftUI

public final class TrainingsListModel: ObservableObject {
    @Published public var trainings: [Training]
    @Published public var destination: Destination?
    
    private var dataManager: DataManager<[Training]>
    
    public enum Destination: Equatable {
        case add(TrainingFormModel)
        
        public static func == (lhs: Destination, rhs: Destination) -> Bool {
            switch (lhs, rhs) {
            case (.add, .add):
                return true
            }
        }
    }
            
    public init(destination: Destination? = nil, dataManager: DataManager<[Training]> = .live) {
        self.destination = destination
        self.dataManager = dataManager
        
        let result = dataManager.read(.trainings)
        switch result {
        case let .success(trainings):
            self.trainings = trainings
        case .failure:
            self.trainings = []
        }
    }
    
    public func addTraining(_ training: Training) {
        self.trainings.append(training)
    }
    
    public func removeTraining(at indexSet: IndexSet) {
        self.trainings.remove(atOffsets: indexSet)
    }
    
    public func addTrainingTapped() {
        self.destination = .add(TrainingFormModel(training: .empty))
    }
    
    public func saveTapped(_ training: Training) {
        addTraining(training)
        self.destination = nil
    }
    
    public func save(at url: URL = .trainings) throws {
        _ = try dataManager.write(url, self.trainings).get()        
    }
}
