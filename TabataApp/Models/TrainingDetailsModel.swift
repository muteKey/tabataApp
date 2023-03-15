import Foundation
import SwiftUI

final class TrainingDetailModel: ObservableObject, Hashable {
    static func == (lhs: TrainingDetailModel, rhs: TrainingDetailModel) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    @Published var training: Training
    @Published var destination: Destination?
    
    enum Destination: Hashable {
        case edit(TrainingFormModel)
        case launch
    }
    
    init(training: Training, destination: Destination? = nil) {
        self.training = training
        self.destination = destination
    }
    
    func editTapped() {
        self.destination = .edit(TrainingFormModel(training: training))
    }
    
    func cancelEditingTapped() {
        self.destination = nil
    }
    
    func saveTapped(_ training: Training) {
        self.training = training
        self.destination = nil
    }
}
