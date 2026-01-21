import Hummingbird
import Foundation
import Common
import RegistryClient
import ImageStore

struct ImageController {
    let imageStore: ImageStore
    let registryClient: RegistryClient
    
    func addRoutes(to group: HBRouterGroup) {
        group.post("/pull", use: pull)
    }
    
    func pull(_ request: HBRequest) async throws -> String {
        guard let req = try? request.decode(as: PullImageRequest.self) else {
            throw HBHTTPError(.badRequest)
        }
        let ref = ImageReference(req.image)
        
        // Fetch Manifest
        let manifest = try await registryClient.getManifest(ref: ref)
        
        // Download layers
        for layer in manifest.layers {
             if !imageStore.hasBlob(digest: layer.digest) {
                 let data = try await registryClient.downloadBlob(ref: ref, digest: layer.digest)
                 try imageStore.storeBlob(data: data, expectedDigest: layer.digest)
             }
        }
        
        // Download Config
        let configDigest = manifest.config.digest
        if !imageStore.hasBlob(digest: configDigest) {
             let data = try await registryClient.downloadBlob(ref: ref, digest: configDigest)
             try imageStore.storeBlob(data: data, expectedDigest: configDigest)
        }
        
        // Unpack
        let slug = req.image.replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: ":", with: "_")
        let rootfs = imageStore.imagesURL.appendingPathComponent(slug).appendingPathComponent("rootfs")
        
        if FileManager.default.fileExists(atPath: rootfs.path) {
            try FileManager.default.removeItem(at: rootfs)
        }
        try FileManager.default.createDirectory(at: rootfs, withIntermediateDirectories: true)
        
         for layer in manifest.layers {
            try imageStore.unpackLayer(digest: layer.digest, to: rootfs)
        }
        
        return "OK"
    }
}
