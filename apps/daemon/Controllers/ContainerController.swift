import Hummingbird
import Foundation
import Common
import Runtime
import ImageStore

struct ContainerController {
    let containerHost: ContainerHost
    let imageStore: ImageStore
    
    func addRoutes(to group: HBRouterGroup) {
        group.post("/create", use: create)
        group.post("/:id/start", use: start)
        group.get("/", use: list)
        group.get("/:id/logs", use: logs)
    }
    
    func create(_ request: HBRequest) throws -> ContainerInfo {
        guard let req = try? request.decode(as: CreateContainerRequest.self) else {
            throw HBHTTPError(.badRequest)
        }
        
        // Error handling for missing image?
        // ContainerHost should throw if image not found?
        // Let's assume ContainerHost handles it or we should check?
        // Ideally ImageStore check here.
        
        let container = try containerHost.createContainer(image: req.image, command: req.command)
        return ContainerInfo(id: container.id, image: container.image, status: container.status.rawValue, pid: container.pid)
    }
    
    func start(_ request: HBRequest) throws -> StartContainerResponse {
        guard let id = request.parameters.get("id") else { throw HBHTTPError(.badRequest) }
        
        let process = try containerHost.startContainer(id: id)
        return StartContainerResponse(pid: process.processIdentifier)
    }
    
    func list(_ request: HBRequest) throws -> [ContainerInfo] {
        let containers = try containerHost.listContainers()
        return containers.map { ContainerInfo(id: $0.id, image: $0.image, status: $0.status.rawValue, pid: $0.pid) }
    }
    
    func logs(_ request: HBRequest) throws -> String {
         guard let id = request.parameters.get("id") else { throw HBHTTPError(.badRequest) }
         
         let logFile = imageStore.containersURL.appendingPathComponent(id).appendingPathComponent("std.log")
         if FileManager.default.fileExists(atPath: logFile.path) {
             return try String(contentsOf: logFile)
         }
         return ""
    }
}
