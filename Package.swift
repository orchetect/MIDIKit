// swift-tools-version:5.5
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "MIDIKit",
    
    platforms: [
        .macOS(.v10_12), .iOS(.v10)
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
        )
    ],
    
    dependencies: [
        .package(url: "https://github.com/orchetect/TimecodeKit", from: "1.3.0"),
        
        // testing-only:
        .package(url: "https://github.com/orchetect/XCTestUtils", from: "1.0.1")
    ],
    
    targets: [
        .target(
            name: "MIDIKit",
            dependencies: [
                .target(name: "MIDIKitCore"),
                .target(name: "MIDIKitIO")
            ]
        ),
        .target(
            name: "MIDIKitInternals",
            dependencies: []
        ),
        .target(
            name: "MIDIKitCore",
            dependencies: [
                .target(name: "MIDIKitInternals")
            ]
        ),
        .target(
            name: "MIDIKitIO",
            dependencies: [
                .target(name: "MIDIKitInternals"),
                .target(name: "MIDIKitCore")
            ]
        ),
        
        // extensions
        .target(
            name: "MIDIKitControlSurfaces",
            dependencies: [
                .target(name: "MIDIKitCore")
            ]
        ),
        .target(
            name: "MIDIKitSMF",
            dependencies: [
                .target(name: "MIDIKitCore"),
                "TimecodeKit"
            ]
        ),
        .target(
            name: "MIDIKitSync",
            dependencies: [
                .target(name: "MIDIKitCore"),
                "TimecodeKit"
            ]
        ),
        
        // test targets
        .testTarget(
            name: "MIDIKitTests",
            dependencies: [
                .target(name: "MIDIKit"),
                .product(name: "XCTestUtils", package: "XCTestUtils")
            ]
        ),
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
        
        // extensions test targets
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
    addShouldTestFlag(toTarget: "MIDIKitTests")
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
