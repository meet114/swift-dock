import ArgumentParser
import Common

struct Logs: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Fetch logs of a container")
    
    @Argument(help: "Container ID")
    var id: String
    
    mutating func run() async throws {
        let client = SwiftdockClient()
        let logs = try await client.getLogs(id: id)
        print(logs, terminator: "")
    }
}
