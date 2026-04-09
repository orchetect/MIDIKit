// swift-tools-version: 6.0

import Foundation
import PackageDescription

let package = Package(
    name: "MIDIKit",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12), // builds, but no MIDI features
        .watchOS(.v4), // builds, but no MIDI features
    ],
    products: [
        .library(
            name: "MIDIKit",
            targets: ["MIDIKit"]
        ),
        .library(
            name: "MIDIKitCore",
            targets: ["MIDIKitCore"]
        ),
        .library(
            name: "MIDIKitIO",
            targets: ["MIDIKitIO"]
        ),
        .library(
            name: "MIDIKitControlSurfaces",
            targets: ["MIDIKitControlSurfaces"]
        ),
        .library(
            name: "MIDIKitSMF",
            targets: ["MIDIKitSMF"]
        ),
        .library(
            name: "MIDIKitSync",
            targets: ["MIDIKitSync"]
        ),
        .library(
            name: "MIDIKitUI",
            targets: ["MIDIKitUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-data-parsing", from: "0.1.2"),
        .package(url: "https://github.com/orchetect/swift-timecode", from: "3.1.0"),
    ],
    targets: [
        .target(
            name: "MIDIKit",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .target(name: "MIDIKitIO"),
                .target(name: "MIDIKitControlSurfaces"),
                .target(name: "MIDIKitSMF"),
                .target(name: "MIDIKitSync"),
                .target(name: "MIDIKitUI"),
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitInternals",
            dependencies: [],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitCore",
            dependencies: [
                .target(name: "MIDIKitInternals"),
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitIO",
            dependencies: [
                .target(name: "MIDIKitInternals"),
                .target(name: "MIDIKitCore"),
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitControlSurfaces",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .target(name: "MIDIKitIO"),
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitSMF",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .target(name: "MIDIKitInternals"),
                .product(name: "SwiftDataParsing", package: "swift-data-parsing"),
                .product(name: "SwiftTimecodeCore", package: "swift-timecode"),
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitSync",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .target(name: "MIDIKitIO"),
                .product(name: "SwiftTimecodeCore", package: "swift-timecode"),
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitUI",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .target(name: "MIDIKitIO"),
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),

        // test targets
        .testTarget(
            name: "MIDIKitCoreTests",
            dependencies: [
                .target(name: "MIDIKitCore"),
            ]
        ),
        .testTarget(
            name: "MIDIKitIOTests",
            dependencies: [
                .target(name: "MIDIKitIO"),
            ]
        ),
        .testTarget(
            name: "MIDIKitControlSurfacesTests",
            dependencies: [
                .target(name: "MIDIKitControlSurfaces"),
            ]
        ),
        .testTarget(
            name: "MIDIKitSMFTests",
            dependencies: [
                .target(name: "MIDIKitSMF"),
            ]
        ),
        .testTarget(
            name: "MIDIKitSyncTests",
            dependencies: [
                .target(name: "MIDIKitSync"),
            ]
        ),
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
