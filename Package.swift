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
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.0.3")
    ],
    
    targets: [
        .target(
            name: "MIDIKit",
            dependencies: [
                .product(name: "SwiftRadix", package: "SwiftRadix")
            ]
        ),
        
        .testTarget(
            name: "MIDIKitTests",
            dependencies: [
                .target(name: "MIDIKit"),
                .product(name: "SwiftRadix", package: "SwiftRadix"),
            ]
        )
    ],
    
    swiftLanguageVersions: [.v5]
    
)
