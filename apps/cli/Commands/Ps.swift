import ArgumentParser
import Common

struct Ps: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "List containers")
    
    mutating func run() async throws {
        let client = SwiftdockClient()
        let list = try await client.listContainers()
        
        print("CONTAINER ID\tIMAGE\t\tSTATUS\tPID")
        for c in list {
            print("\(c.id.prefix(12))\t\(c.image)\t\(c.status)\t\(c.pid ?? 0)")
        }
    }
}
