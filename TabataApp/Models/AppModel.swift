import SwiftUI
import Combine

class AppModel: ObservableObject {
    enum Destination: Hashable {
        case detail(TrainingDetailModel)
        case launch(TrainingLaunchModel)
    }

    @Published var path: [Destination] {
        didSet { self.bind() }
    }
    
    init(path: [Destination]) {
        self.path = path
    }
    
    private func bind() {
        for destination in path {
            switch destination {
            case let .launch(model):
                model.onStop = { [weak self] in
                    guard let self else { return }
                    self.path.removeAll()
                }
                model.onFinish = { [weak self] in
                    guard let self else { return }
                    self.path.removeAll()
                }
            default:
                break
            }
        }
    }
}
