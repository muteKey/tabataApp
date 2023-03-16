import Foundation

extension URL {
    static let trainings = Self.documentsDirectory.appending(component: "trainings.json")
}

final class DataManager {
    func loadData(from url: URL) throws -> Data {
        if !FileManager.default.fileExists(atPath: url.path()) {
            FileManager.default.createFile(atPath: url.path, contents: nil)
        }
        return try Data(contentsOf: url)
    }
    
    func saveData(data: Data, url: URL = .trainings) throws {
        if !FileManager.default.fileExists(atPath: url.path()) {
            FileManager.default.createFile(atPath: url.path, contents: nil)
        }
        try data.write(to: url)
    }
}
