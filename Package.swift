// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "swiftdock",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "swiftdock", targets: ["std-cli"]),
        .executable(name: "swiftdockd", targets: ["daemon"]),
        .library(name: "Common", targets: ["Common"]),
        .library(name: "RegistryClient", targets: ["RegistryClient"]),
        .library(name: "ImageStore", targets: ["ImageStore"]),
        .library(name: "OCISpec", targets: ["OCISpec"]),
    ],
    dependencies: [
        // Add dependencies here (e.g., swift-argument-parser, swift-nio, swift-log)
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "1.0.0"),
    ],
    targets: [
        // Apps
        .executableTarget(
            name: "std-cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Common",
                "RegistryClient",
                "ImageStore",
                "Runtime"
            ],
            path: "apps/cli"
        ),
        .executableTarget(
            name: "daemon",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdFoundation", package: "hummingbird"),
                "Common",
                "ImageStore",
                "OCISpec",
                "Runtime",
                "RegistryClient"
            ],
            path: "apps/daemon"
        ),
        
        // Packages
        .target(name: "Common", path: "packages/Common"),
        .target(name: "RegistryClient", dependencies: ["Common", "OCISpec"], path: "packages/RegistryClient"),
        .target(name: "ImageStore", dependencies: ["Common", "OCISpec"], path: "packages/ImageStore"),
        .target(name: "OCISpec", dependencies: ["Common"], path: "packages/OCISpec"),
        .target(name: "Runtime", dependencies: ["Common", "ImageStore"], path: "packages/Runtime"),
        .target(name: "SwiftdockLogging", dependencies: ["Common"], path: "packages/SwiftdockLogging"),
        
        // Tests
        .testTarget(name: "CommonTests", dependencies: ["Common"]),
    ]
)
