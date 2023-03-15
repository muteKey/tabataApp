import SwiftUI
import Combine

final class TimerModel: ObservableObject {
    enum State {
        case stopped
        case paused
        case running
    }
    
    @Published var state: State
    
    @Published private(set) var timerPublisher: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    
    var cancellable: Cancellable?

    init(state: State = .stopped) {
        self.state = state
        self.resumeTimer()
    }
    
    func stopTimer() {
        state = .stopped
        stop()
    }
    
    func pauseTimer() {
        state = .paused
        stop()
    }
    
    func resumeTimer() {
        state = .running
        timerPublisher = Timer.publish(every: 1, on: .main, in: .common)
        cancellable = timerPublisher.connect()
    }
    
    private func stop() {
        cancellable?.cancel()
        cancellable = nil
    }
}
