import XCTest
@testable import Common

final class ImageReferenceTests: XCTestCase {
    func testParsing() {
        let cases: [(String, String, String, String)] = [
            ("alpine", "docker.io", "library/alpine", "latest"),
            ("alpine:3.14", "docker.io", "library/alpine", "3.14"),
            ("library/ubuntu", "docker.io", "library/ubuntu", "latest"),
            ("myregistry.local:5000/foo/bar", "myregistry.local:5000", "foo/bar", "latest"),
            ("ghcr.io/owner/repo:v1", "ghcr.io", "owner/repo", "v1"),
        ]
        
        for (input, reg, repo, tag) in cases {
            let ref = ImageReference(input)
            XCTAssertEqual(ref.registry, reg, "Registry failed for \(input)")
            XCTAssertEqual(ref.repository, repo, "Repository failed for \(input)")
            XCTAssertEqual(ref.tag, tag, "Tag failed for \(input)")
        }
    }
}
