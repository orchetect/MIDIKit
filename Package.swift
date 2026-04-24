// swift-tools-version: 6.0

import Foundation
import PackageDescription

let package = Package(
    name: "swift-midi",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "SwiftMIDI",
            targets: ["SwiftMIDI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-midi-controlsurfaces", branch: "main"), // TODO: from: "1.0.0"),
        .package(url: "https://github.com/orchetect/swift-midi-core", branch: "main"), // TODO: from: "1.0.0"),
        .package(url: "https://github.com/orchetect/swift-midi-file", branch: "main"), // TODO: from: "1.0.0"),
        .package(url: "https://github.com/orchetect/swift-midi-io", branch: "main"), // TODO: from: "1.0.0"),
        .package(url: "https://github.com/orchetect/swift-midi-sync", branch: "main"), // TODO: from: "1.0.0"),
        .package(url: "https://github.com/orchetect/swift-midi-ui", branch: "main") // TODO: from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SwiftMIDI",
            dependencies: [
                .product(name: "SwiftMIDIControlSurfaces", package: "swift-midi-controlsurfaces"),
                .product(name: "SwiftMIDICore", package: "swift-midi-core"),
                .product(name: "SwiftMIDIFile", package: "swift-midi-file"),
                .product(name: "SwiftMIDIIO", package: "swift-midi-io"),
                .product(name: "SwiftMIDISync", package: "swift-midi-sync"),
                .product(name: "SwiftMIDIUI", package: "swift-midi-ui")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        )
    ]
)

#if canImport(Foundation) || canImport(CoreFoundation)
    #if canImport(Foundation)
        import class Foundation.ProcessInfo

        func getEnvironmentVar(_ name: String) -> String? {
            ProcessInfo.processInfo.environment[name]
        }

    #elseif canImport(CoreFoundation)
        import CoreFoundation

        func getEnvironmentVar(_ name: String) -> String? {
            guard let rawValue = getenv(name) else { return nil }
            return String(utf8String: rawValue)
        }
    #endif

    func isEnvironmentVarTrue(_ name: String) -> Bool {
        guard let value = getEnvironmentVar(name)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        else { return false }
        return ["true", "yes", "1"].contains(value.lowercased())
    }

    // MARK: - DocC Dependency

    // Conditionally opt-in to Swift DocC Plugin when an environment flag is present.
    if isEnvironmentVarTrue("ENABLE_DOCC_PLUGIN") {
        package.dependencies += [
            .package(url: "https://github.com/swiftlang/swift-docc-plugin.git", from: "1.4.5"),
        ]
    }

    // MARK: - CI Pipeline

    if isEnvironmentVarTrue("GITHUB_ACTIONS") {
        for target in package.targets.filter(\.isTest) {
            if target.swiftSettings == nil { target.swiftSettings = [] }
            target.swiftSettings? += [.define("GITHUB_ACTIONS", .when(configuration: .debug))]
        }
    }
#endif
