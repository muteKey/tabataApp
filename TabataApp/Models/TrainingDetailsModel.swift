import Foundation
import SwiftUI

final class TrainingDetailModel: ObservableObject {
    var training: Binding<Training>
    
    enum Destination {
        case launchTraining
    }
    
    init(training: Binding<Training>) {
        self.training = training
    }
    
    func addLap() {
        let defaultLap = Training.Lap(breakDuration: 60, workDuration: 30)
        self.training.wrappedValue.laps.append(defaultLap)
    }
    
    func removeLap(_ lap: Training.Lap) {
        self.training.wrappedValue.laps.removeAll { $0.id == lap.id }
    }
}
