import Foundation
import Combine

public extension URL {
    static let trainings = Self.documentsDirectory.appending(component: "trainings.json")
}

public final class DataManager<T> {
    public let write: (URL, T)  -> Result<Void, Error>
    public let read: (URL) -> Result<T, Error>
    
    public init(write: @escaping (URL, T) -> Result<Void, Error>, read: @escaping (URL) -> Result<T, Error>) {
        self.write = write
        self.read = read
    }
}

public extension DataManager where T: Codable {
    static var live: DataManager {
        DataManager { (url, models: T) in
            if !FileManager.default.fileExists(atPath: url.path()) {
                FileManager.default.createFile(atPath: url.path(), contents: nil)
            }
            do {
                let data = try JSONEncoder().encode(models)
                try data.write(to: url)
                return Result.success(())
            } catch {
                return Result.failure(error)
            }
        } read: { url in
            if !FileManager.default.fileExists(atPath: url.path()) {
                FileManager.default.createFile(atPath: url.path(), contents: nil)
            }
            do {
                let data = try Data(contentsOf: url)
                if data.isEmpty {
                    return Result.success([] as! T)
                }
                let objects = try JSONDecoder().decode(T.self, from: data)
                return Result.success(objects)
            } catch {
                return .failure(error)
            }
        }
    }
}

