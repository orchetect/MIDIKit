// swift-tools-version: 5.9
// (be sure to update the .swift-version file when this Swift version changes)

import Foundation
import PackageDescription

let package = Package(
    name: "MIDIKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13), // builds, but no MIDI features
        .watchOS(.v6) // builds, but no MIDI features
    ],
    products: [
        .library(
            name: "MIDIKit",
            type: .static,
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
        )
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/TimecodeKit", from: "2.3.3")
    ] + doccPluginDependency(),
    targets: [
        .target(
            name: "MIDIKit",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .target(name: "MIDIKitIO"),
                .target(name: "MIDIKitControlSurfaces"),
                .target(name: "MIDIKitSMF"),
                .target(name: "MIDIKitSync"),
                .target(name: "MIDIKitUI")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitInternals",
            dependencies: [],
            resources: [.process("PrivacyInfo.xcprivacy")],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitCore",
            dependencies: [
                .target(name: "MIDIKitInternals")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitIO",
            dependencies: [
                .target(name: "MIDIKitInternals"),
                .target(name: "MIDIKitCore")
            ],
            resources: [.process("PrivacyInfo.xcprivacy")],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitControlSurfaces",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .target(name: "MIDIKitIO")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitSMF",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .product(name: "TimecodeKitCore", package: "TimecodeKit")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitSync",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .target(name: "MIDIKitIO"),
                .product(name: "TimecodeKitCore", package: "TimecodeKit")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitUI",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .target(name: "MIDIKitIO")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        
        // test targets
        .testTarget(
            name: "MIDIKitCoreTests",
            dependencies: [
                .target(name: "MIDIKitCore")
            ]
        ),
        .testTarget(
            name: "MIDIKitIOTests",
            dependencies: [
                .target(name: "MIDIKitIO")
            ]
        ),
        .testTarget(
            name: "MIDIKitControlSurfacesTests",
            dependencies: [
                .target(name: "MIDIKitControlSurfaces")
            ]
        ),
        .testTarget(
            name: "MIDIKitSMFTests",
            dependencies: [
                .target(name: "MIDIKitSMF")
            ]
        ),
        .testTarget(
            name: "MIDIKitSyncTests",
            dependencies: [
                .target(name: "MIDIKitSync")
            ]
        )
    ]
)

/// Conditionally opt-in to Swift DocC Plugin when an environment flag is present.
func doccPluginDependency() -> [Package.Dependency] {
    ProcessInfo.processInfo.environment["ENABLE_DOCC_PLUGIN"] != nil
        ? [.package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.4.3")]
        : []
}
