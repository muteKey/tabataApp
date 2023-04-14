import SwiftUI
import Combine

public final class TimerModel: ObservableObject {
    public enum State {
        case stopped
        case paused
        case running
    }
    
    @Published public var state: State
    
    @Published public private(set) var timerPublisher: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    
    public private(set) var cancellable: Cancellable?

    public init(state: State = .stopped) {
        self.state = state
        self.resumeTimer()
    }
    
    public func stopTimer() {
        state = .stopped
        stop()
    }
    
    public func pauseTimer() {
        state = .paused
        stop()
    }
    
    public func resumeTimer() {
        state = .running
        timerPublisher = Timer.publish(every: 1, on: .main, in: .common)
        cancellable = timerPublisher.connect()
    }
    
    private func stop() {
        cancellable?.cancel()
        cancellable = nil
    }
}
