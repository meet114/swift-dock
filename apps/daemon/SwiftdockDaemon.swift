import Hummingbird
import HummingbirdFoundation
import Foundation
import Common
import RegistryClient
import ImageStore
import Runtime

@main
struct SwiftdockDaemon {
    static func main() async throws {
        let app = HBApplication(configuration: .init(address: .hostname("127.0.0.1", port: 8080)))
        app.encoder = JSONEncoder()
        app.decoder = JSONDecoder()
        
        // Init Singletons
        let imageStore = ImageStore()
        try imageStore.initialize()
        let containerHost = ContainerHost(imageStore: imageStore)
        let registryClient = RegistryClient() // Shared session?
        
        // Routes
        app.router.get("/health") { _ in
            return "OK"
        }
        
        let imageController = ImageController(imageStore: imageStore, registryClient: registryClient)
        imageController.addRoutes(to: app.router.group("/images"))
        
        let containerController = ContainerController(containerHost: containerHost, imageStore: imageStore)
        containerController.addRoutes(to: app.router.group("/containers"))
        
        try app.start()
        
        // Keep running indefinitely
        try await Task.sleep(nanoseconds: UInt64.max)
    }
}

extension ContainerInfo: HBResponseCodable {}
extension StartContainerResponse: HBResponseCodable {}
// String implicitly conforms.
