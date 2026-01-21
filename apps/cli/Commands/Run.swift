import ArgumentParser
import Common
import Foundation

struct Run: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Run a command in a new container")
    
    @Argument(help: "Image reference")
    var image: String
    
    @Argument(parsing: .captureForPassthrough, help: "Command to execute")
    var command: [String] = []
    
    mutating func run() async throws {
        let client = SwiftdockClient()
        
        // 1. Create
        print("Creating container for \(image)...")
        var finalCommand = command
        if finalCommand.first == "--" {
            finalCommand.removeFirst()
        }
        if finalCommand.isEmpty {
             print("Error: No command specified.")
             return
        }
        
        let container = try await client.createContainer(image: image, command: finalCommand)
        print("Created \(container.id)")
        
        // 2. Start
        print("Starting...")
        let pid = try await client.startContainer(id: container.id)
        print("Started with PID \(pid)")
        
        // Polling for demo purposes
        print("(Polling for exit...)")
        while true {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5s
            let list = try await client.listContainers()
            if let c = list.first(where: { $0.id == container.id }), c.status == "exited" {
                print("Container exited.")
                break
            }
        }
        
        // Fetch logs at end
        let logs = try await client.getLogs(id: container.id)
        print(logs, terminator: "")
    }
}
