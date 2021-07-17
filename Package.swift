// swift-tools-version:5.3

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
            targets: ["MIDIKit"])
    ],
    
    dependencies: [
        // Boilerplate
        .package(url: "https://github.com/orchetect/OTCore", from: "1.1.8"),
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.0.1"),
        
        // Timecode
        .package(url: "https://github.com/orchetect/TimecodeKit", from: "1.1.2")
    ],
    
    targets: [
        // MIDIKit main library
        .target(
            name: "MIDIKit",
            dependencies: [
                // internal
                .target(name: "MIDIKitC"),
                // external
                .product(name: "OTCore", package: "OTCore"),
                .product(name: "OTCore-Testing", package: "OTCore"),
                .product(name: "SwiftRadix", package: "SwiftRadix")
            ]
        ),
        
        // MIDIKit internal C functions
        .target(
            name: "MIDIKitC",
            dependencies: [],
            publicHeadersPath: ".",
            cxxSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        .testTarget(
            name: "MIDIKitTests",
            dependencies: [
                // internal
                .target(name: "MIDIKit"),
                // external
                .product(name: "OTCore-Testing-XCTest", package: "OTCore"),
                .product(name: "SwiftRadix", package: "SwiftRadix"),
                .product(name: "TimecodeKit", package: "TimecodeKit")
            ]
        )
    ]
    
)
