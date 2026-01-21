import ArgumentParser
import Common

struct Pull: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Pull an image from a daemon")
    
    @Argument(help: "Image reference (e.g. alpine:latest)")
    var image: String
    
    mutating func run() async throws {
        let client = SwiftdockClient()
        print("Pulling \(image) via daemon...")
        try await client.pullImage(image: image)
        print("Successfully pulled \(image)")
    }
}
