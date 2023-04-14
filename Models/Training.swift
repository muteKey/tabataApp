import Foundation

public protocol Validatable {
    var isValid: Bool { get }
}

public enum ValidatedFieldState {
    case valid
    case invalid(String)
    
    var isValid: Bool {
        if case .valid = self { return true }
        return false
    }
}

public struct Training: Identifiable, Hashable, Codable {
    public var id = UUID()
    public var title: String
    public var laps: [Lap]
    public var breakBetweenLaps: Int
    
    public init(id: UUID = UUID(), title: String, laps: [Lap], breakBetweenLaps: Int) {
        self.id = id
        self.title = title
        self.laps = laps
        self.breakBetweenLaps = breakBetweenLaps
    }
    
    public struct Lap: Identifiable, Hashable, Codable {
        public var id = UUID()
        public var phases: [Phase]
        
        public init(id: UUID = UUID(), phases: [Phase]) {
            self.id = id
            self.phases = phases
        }
    }
    
    public struct Phase: Identifiable, Hashable, Codable {
        public var id = UUID()
        public var breakDuration: Int
        public var workDuration: Int
        public var title: String
        
        public init(id: UUID = UUID(), breakDuration: Int, workDuration: Int, title: String) {
            self.id = id
            self.breakDuration = breakDuration
            self.workDuration = workDuration
            self.title = title
        }
    }
}

extension Training: Validatable {
    public var isValid: Bool {
        return !title.isEmpty && laps.isValid && breakBetweenLaps > 0
    }
}

extension Training.Lap: Validatable {
    public var isValid: Bool {
        return phases.isValid
    }
}

extension Training.Phase: Validatable {
    public var isValid: Bool {
        return breakDuration > 0 && workDuration > 0 && !title.isEmpty
    }
}

public extension Training.Phase {
    static var `default`: Self {
        Training.Phase(breakDuration: 5, workDuration: 10, title: "")
    }
}

extension Array: Validatable where Element: Validatable {
    public var isValid: Bool {
        if self.isEmpty {
            return false
        }
        for el in self {
            if !el.isValid { return false }
        }
        return true
    }
}

public extension Training {
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

public extension Training {
    static var empty: Training {
        Training(title: "", laps: [], breakBetweenLaps: 0)
    }
}
