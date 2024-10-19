// swift-tools-version: 5.9
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "MIDIKit",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12), // builds, but no MIDI features
        .watchOS(.v4) // builds, but no MIDI features
    ],
    products: [
        .library(
            name: "MIDIKit",
            type: .static,
            targets: ["MIDIKit"]
        ),
        .library(
            name: "MIDIKitCore",
            type: .static,
            targets: ["MIDIKitCore"]
        ),
        .library(
            name: "MIDIKitIO",
            type: .static,
            targets: ["MIDIKitIO"]
        ),
        .library(
            name: "MIDIKitControlSurfaces",
            type: .static,
            targets: ["MIDIKitControlSurfaces"]
        ),
        .library(
            name: "MIDIKitSMF",
            type: .static,
            targets: ["MIDIKitSMF"]
        ),
        .library(
            name: "MIDIKitSync",
            type: .static,
            targets: ["MIDIKitSync"]
        ),
        .library(
            name: "MIDIKitUI",
            type: .static,
            targets: ["MIDIKitUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/TimecodeKit", from: "2.3.0"),
        
        // testing only:
        .package(url: "https://github.com/orchetect/XCTestUtils", from: "1.0.3")
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
                .target(name: "MIDIKitCore")
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
                .product(name: "TimecodeKitCore", package: "TimecodeKit")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitUI",
            dependencies: [
                .target(name: "MIDIKitIO")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        
        // test targets
        .testTarget(
            name: "MIDIKitCoreTests",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .product(name: "XCTestUtils", package: "XCTestUtils")
            ]
        ),
        .testTarget(
            name: "MIDIKitIOTests",
            dependencies: [
                .target(name: "MIDIKitIO"),
                .product(name: "XCTestUtils", package: "XCTestUtils")
            ]
        ),
        .testTarget(
            name: "MIDIKitControlSurfacesTests",
            dependencies: [
                .target(name: "MIDIKitControlSurfaces"),
                .product(name: "XCTestUtils", package: "XCTestUtils")
            ]
        ),
        .testTarget(
            name: "MIDIKitSMFTests",
            dependencies: [
                .target(name: "MIDIKitSMF"),
                .product(name: "XCTestUtils", package: "XCTestUtils")
            ]
        ),
        .testTarget(
            name: "MIDIKitSyncTests",
            dependencies: [
                .target(name: "MIDIKitSync"),
                .product(name: "XCTestUtils", package: "XCTestUtils")
            ]
        )
    ]
)
