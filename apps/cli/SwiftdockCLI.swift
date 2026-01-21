import ArgumentParser
import Foundation
import Common

@main
struct Swiftdock: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A native macOS container runtime and management tool. (Client Mode)",
        subcommands: [Pull.self, Run.self, Ps.self, Logs.self]
    )
    
    mutating func run() throws {
        print("swiftdock CLI v0.1.0")
    }
}
