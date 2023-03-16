import Foundation

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
