// swift-tools-version:5.3

import PackageDescription

let package = Package(
    
    name: "MIDIKit",
    
    platforms: [
        .macOS(.v10_12), .iOS(.v10) // , .tvOS(.v14), .watchOS(.v7) - still in beta
    ],
    
    products: [
        .library(
            name: "MIDIKit",
            type: .static,
            targets: ["MIDIKit"])
    ],
    
    dependencies: [
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.0.3")
    ],
    
    targets: [
        .target(
            name: "MIDIKit",
            dependencies: [
                .target(name: "MIDIKitC"),
                .product(name: "SwiftRadix", package: "SwiftRadix")
            ]
        ),
        
        .target(
            name: "MIDIKitC",
            dependencies: [],
            publicHeadersPath: ".",
            cxxSettings: [
                .headerSearchPath(".")
            ]
        ),
        
        .target(name: "XCTestExtensions"),
        
        .testTarget(
            name: "MIDIKitTests",
            dependencies: [
                .target(name: "MIDIKit"),
                .product(name: "SwiftRadix", package: "SwiftRadix"),
                .target(name: "XCTestExtensions")
            ]
        )
    ]
    
)
