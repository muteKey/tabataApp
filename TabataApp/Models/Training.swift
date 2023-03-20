import Foundation

protocol Validatable {
    var isValid: Bool { get }
}

struct Training: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var laps: [Lap]
    var breakBetweenLaps: Int
    
    struct Lap: Identifiable, Hashable, Codable {
        var id = UUID()
        var phases: [Phase]
    }
    
    struct Phase: Identifiable, Hashable, Codable {
        var id = UUID()
        var breakDuration: Int
        var workDuration: Int
        var title: String
    }
}

extension Training: Validatable {
    var isValid: Bool {
        return !title.isEmpty && laps.isValid && breakBetweenLaps > 0
    }
}

extension Training.Lap: Validatable {
    var isValid: Bool {
        return phases.isValid
    }
}

extension Training.Phase: Validatable {
    var isValid: Bool {
        return breakDuration > 0 && workDuration > 0 && !title.isEmpty
    }
}

extension Array: Validatable where Element: Validatable {
    var isValid: Bool {
        if self.isEmpty {
            return false
        }
        for el in self {
            if !el.isValid { return false }
        }
        return true
    }
}

extension Training {
    var totalDuration: Int {
        var total = 0
        
        for lap in laps {
            total += breakBetweenLaps
            for phase in lap.phases {
                total += phase.workDuration
                total += phase.breakDuration
            }
        }
        return total
    }
}


extension Training {
    static var mock: Self {
        return Training(title: "First Training",
                        laps: [
                            Training.Lap(phases: [
                                Phase(breakDuration: 5, workDuration: 60, title: "Section 0"),
                                Phase(breakDuration: 5, workDuration: 60, title: "Section 0")
                            ]),
                            
                            Training.Lap(phases: [
                                Phase(breakDuration: 5, workDuration: 60, title: "Section 1"),
                                Phase(breakDuration: 5, workDuration: 60, title: "Section 1")
                            ])
                        ],
                        breakBetweenLaps: 10)
    }
}
