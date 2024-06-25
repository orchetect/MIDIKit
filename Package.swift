// swift-tools-version: 5.6
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "MIDIKit",
    
    platforms: platforms(),
        
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
        .package(url: "https://github.com/orchetect/TimecodeKit", from: "2.0.11"),
        
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
                "TimecodeKit"
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "MIDIKitSync",
            dependencies: [
                .target(name: "MIDIKitCore"),
                "TimecodeKit"
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
    ],
    
    swiftLanguageVersions: [.v5]
)

// MARK: - Platforms

/// Return a set of platforms depending on the version of Swift/Xcode being used
/// just so we can suppress compile warnings for older operating system versions.
///
/// - Note: See [Apple Xcode Requirements](https://developer.apple.com/support/xcode/)
func platforms() -> [SupportedPlatform] {
    #if swift(>=5.7)
    // Xcode 14.0.x
    // - added Swift 5.7 support
    // - pushed minimum macOS SDK to 10.13
    // - pushed minimum iOS SDK to 11.0
    [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11), // builds, but no MIDI features
        .watchOS(.v4) // builds, but no MIDI features
    ]
    #else // Swift 5.6 (oldest Swift toolchain supported for the Package)
    [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10), // builds, but no MIDI features
        .watchOS(.v3) // builds, but no MIDI features
    ]
    #endif
}

// MARK: - Unit Testing

func addShouldTestFlag(toTarget targetName: String) {
    // swiftSettings may be nil so we can't directly append to it
    
    var swiftSettings = package.targets
        .first(where: { $0.name == targetName })?
        .swiftSettings ?? []
    
    swiftSettings.append(.define("shouldTestCurrentPlatform"))
    
    package.targets
        .first(where: { $0.name == targetName })?
        .swiftSettings = swiftSettings
}

func addShouldTestFlags() {
    addShouldTestFlag(toTarget: "MIDIKitCoreTests")
    addShouldTestFlag(toTarget: "MIDIKitIOTests")
    addShouldTestFlag(toTarget: "MIDIKitControlSurfacesTests")
    addShouldTestFlag(toTarget: "MIDIKitSMFTests")
    addShouldTestFlag(toTarget: "MIDIKitSyncTests")
}

// Swift version in Xcode 12.5.1 which introduced watchOS testing
#if os(watchOS) && swift(>=5.4.2)
addShouldTestFlags()
#elseif os(watchOS)
// don't add flag
#else
addShouldTestFlags()
#endif
