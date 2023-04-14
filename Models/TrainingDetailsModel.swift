import Foundation
import SwiftUI

public final class TrainingDetailModel: ObservableObject, Hashable {
    public static func == (lhs: TrainingDetailModel, rhs: TrainingDetailModel) -> Bool {
        lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    @Published public var training: Training
    @Published public var destination: Destination?
    
    public enum Destination: Hashable, Equatable {
        case edit(TrainingFormModel)
        case launch
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.edit, .edit),
                (.launch, .launch):
                return true
            case (.edit, .launch), (.launch, .edit):
                return false
            }
        }
    }
    
    public init(training: Training, destination: Destination? = nil) {
        self.training = training
        self.destination = destination
    }
    
    public func editTapped() {
        self.destination = .edit(TrainingFormModel(training: training))
    }
    
    public func cancelEditingTapped() {
        self.destination = nil
    }
    
    public func saveTapped(_ training: Training) {
        self.training = training
        self.destination = nil
    }
}
