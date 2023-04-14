import SwiftUI
import Combine

public class AppModel: ObservableObject {
    public enum Destination: Hashable, Equatable {
        case detail(TrainingDetailModel)
        case launch(TrainingLaunchModel)
    }
    
    private struct Constants {
        static let saveInterval = 5.0
    }
    
    private var autosaveTimer: Timer?

    @Published public var path: [Destination] {
        didSet { self.bind() }
    }
    
    private var detailCancellable: AnyCancellable?
    @Published public var trainingsList: TrainingsListModel
    
    public init(path: [Destination], trainingsList: TrainingsListModel) {
        self.path = path
        self.trainingsList = trainingsList
        self.scheduleAutosave()
    }
    
    private func bind() {
        for destination in path {
            switch destination {
            case let .detail(model):
                bindDetail(model: model)
            case let .launch(model):
                model.onStop = { [weak self] in
                    guard let self else { return }
                    self.path.removeAll()
                }
                model.onFinish = { [weak self] in
                    guard let self else { return }
                    self.path.removeAll()
                }
            }
        }
    }
    
    private func bindDetail(model: TrainingDetailModel) {
        self.detailCancellable = model.$training.sink(receiveValue: { [weak self] training in
            guard let index = self?.trainingsList.trainings.firstIndex(where: { $0.id == training.id }) else { return }
            self?.trainingsList.trainings[index] = training
        })
    }
    
    private func scheduleAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: Constants.saveInterval, repeats: true, block: { _ in
            do {
                try self.trainingsList.save()
            } catch {
                print(error)
            }
        })
        
    }
 }
