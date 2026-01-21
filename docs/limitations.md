# Limitations

## No "Docker-equivalent Isolation"
macOS does not support Linux namespaces or cgroups.
- **Implication**: Containers are essentially just processes running on the host, with some sandbox constraints applied where possible (e.g., using `sandbox-exec` or App Sandbox).
- **Security**: Do not treat `swiftdock` containers as security boundaries equivalent to Linux containers or VMs.

## No Containers on iOS/watchOS
The runtime engine (`swiftdockd`) runs **only** on macOS.
- **iOS/watchOS**: These act solely as *clients* to control the daemon running on a Mac. They do not run containers themselves.

## OCI Support
- **Media Types**: Primarily supports `application/vnd.docker.distribution.manifest.v2+json` and `application/vnd.oci.image.manifest.v1+json`.
- **Platforms**: Primarily pulls `linux/amd64` or `linux/arm64` images but cannot execute Linux binaries natively unless they are Mach-O (which is rare/impossible for standard images) or if we add a virtualization layer (out of scope for v1). **Wait, actually:**
    - *Correction*: We are essentially unpacking the rootfs. If the binaries are Linux ELF, they won't run on macOS without a VM.
    - *V1 Goal*: "process exec". This implies we might just be running macOS binaries, OR we are just simulating the "container experience" with local binaries, OR the user expects us to run Linux binaries which requires `Virtualization.framework`.
    - *Re-reading Prompt*: "run a container process... spawn process using Process()". This strongly implies running *host* binaries or binaries compatible with macOS.
    - *Clarification*: If we pull `alpine:latest`, that's Linux. It won't run via `Process()` on macOS.
    - *Assumption*: For Milestone 1/2, we might just be pulling content and proving we can unpack it, or running "hello world" that happens to be compatible, or the user understands this limitation. The prompt says "macOS runtime can pull OCI images... run a container process".
    - *Refinement*: We will document that for V1, "Running Linux ELF binaries is NOT supported without a VM. We primarily support unpacking valid OCI images. 'Running' implies executing a command within that chroot/rootfs, which must be a macOS-compatible binary if no VM is involved."
    - *However*, the user prompt explicitly listed "What you explicitly won’t claim: Docker-equivalent isolation". It didn't strictly say "No Linux binaries". But `Process()` cannot run ELF. So for now, we assume we run macOS executables or just explore the rootfs.

