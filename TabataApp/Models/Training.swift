import Foundation

struct Training: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var laps: [Lap]
    var breakBetweenLaps: Int
    
    struct Lap: Identifiable, Hashable {
        let id = UUID()
        var breakDuration: Int
        var workDuration: Int        
    }
}

extension Training {
    var totalDuration: Int {
        let totalBreak = laps.count * breakBetweenLaps
        let lapDuration = laps.reduce(0, { duration, lap in
            duration + lap.breakDuration + lap.workDuration
        })
        return totalBreak + lapDuration
    }
}

extension Training {
    static var mock: Self {
        return Training(title: "First Training", laps: [], breakBetweenLaps: 10)
    }
}
