// swift-tools-version:5.3

import PackageDescription

let package = Package(
	
	name: "MIDIKit",
	
	platforms: [
		.macOS(.v10_12), .iOS(.v10)
	],
	
	products: [
		
		// ---------------------------------------------
		// ROOT LIBRARY
		// ---------------------------------------------
		
		.library(
			name: "MIDIKit",
			type: .static,
			targets: ["MIDIKit", "MIDIKitIO", "MIDIKitEvents"]),
		
		// ---------------------------------------------
		// MODULES
		// ---------------------------------------------
		
		.library(
			name: "MIDIKitIO",
			type: .static,
			targets: ["MIDIKitIO"]),
		
		.library(
			name: "MIDIKitEvents",
			type: .static,
			targets: ["MIDIKitEvents"]),
		
		.library(
			name: "MIDIKitSync",
			type: .static,
			targets: ["MIDIKitSync"])
		
	],
	
	dependencies: [
		
		// Boilerplate
		.package(url: "https://github.com/orchetect/OTCore", from: "1.1.6"),
		.package(url: "https://github.com/orchetect/SwiftRadix", from: "1.0.1"),
		
		// Timecode
		.package(url: "https://github.com/orchetect/TimecodeKit", from: "1.1.0")
		
	],
	
	targets: [
		
		// ---------------------------------------------
		// ROOT LIBRARY
		// ---------------------------------------------
		
		// MIDIKit entire library
		.target(
			name: "MIDIKit",
			dependencies: [
				.target(name: "MIDIKitCommon"),
				.target(name: "MIDIKitInternals"),
				.target(name: "MIDIKitC"),
				.target(name: "MIDIKitIO"),
				.target(name: "MIDIKitEvents"),
				.target(name: "MIDIKitSync"),
			]
		),
		
		// ---------------------------------------------
		// MODULES
		// ---------------------------------------------
		
		// MIDIKit IO module
		.target(
			name: "MIDIKitIO",
			dependencies: [
				.target(name: "MIDIKitCommon"),
				.target(name: "MIDIKitInternals"),
				.target(name: "MIDIKitC"),
				.product(name: "OTCore", package: "OTCore"),
				.product(name: "SwiftRadix", package: "SwiftRadix")
			]
		),
		
		// MIDIKit Events module
		.target(
			name: "MIDIKitEvents",
			dependencies: [
				.target(name: "MIDIKitCommon"),
				.target(name: "MIDIKitInternals"),
				.product(name: "OTCore", package: "OTCore"),
				.product(name: "SwiftRadix", package: "SwiftRadix")
			]
		),
		
		// MIDIKit Sync module (MTC, MMC, etc.)
		.target(
			name: "MIDIKitSync",
			dependencies: [
				.target(name: "MIDIKitCommon"),
				.target(name: "MIDIKitInternals"),
				.product(name: "OTCore", package: "OTCore"),
				.product(name: "SwiftRadix", package: "SwiftRadix"),
				.product(name: "TimecodeKit", package: "TimecodeKit")
			]
		),
		
		// ---------------------------------------------
		// COMMON MODULE
		// ---------------------------------------------
		
		// MIDIKit common
		.target(
			name: "MIDIKitCommon",
			dependencies: [
				.product(name: "OTCore", package: "OTCore"),
				.product(name: "OTCore-Testing", package: "OTCore")
			]
		),
		

		// MIDIKit internals
		.target(
			name: "MIDIKitInternals",
			dependencies: [
				// none
			]
		),
		
		// MIDIKit C functions
		.target(
			name: "MIDIKitC",
			dependencies: [
				// none
			],
			publicHeadersPath: ".",
			cxxSettings: [
				.headerSearchPath(".")
			]
		),
		
		// test common
		.target(
			name: "MIDIKitTestsCommon",
			dependencies: [
				.product(name: "OTCore-Testing-XCTest", package: "OTCore")
			]
		),
		
		// ---------------------------------------------
		// UNIT TESTS
		// ---------------------------------------------
		
		// MIDIKit entire library tests
		.testTarget(
			name: "MIDIKitTests",
			dependencies: [
				.target(name: "MIDIKitTestsCommon"),
				.target(name: "MIDIKit"),
				.product(name: "SwiftRadix", package: "SwiftRadix")
			]
		),
		
		// MIDIKit common submodule tests
		.testTarget(
			name: "MIDIKitCommonTests",
			dependencies: [
				.target(name: "MIDIKitTestsCommon"),
				.target(name: "MIDIKitCommon"),
			]
		),
		
		// MIDIKit IO submodule tests
		.testTarget(
			name: "MIDIKitIOTests",
			dependencies: [
				.target(name: "MIDIKitTestsCommon"),
				.target(name: "MIDIKitIO"),
				.product(name: "SwiftRadix", package: "SwiftRadix")
			]
		),
		
		// MIDIKit Events submodule tests
		.testTarget(
			name: "MIDIKitEventsTests",
			dependencies: [
				.target(name: "MIDIKitTestsCommon"),
				.target(name: "MIDIKitEvents"),
				.product(name: "SwiftRadix", package: "SwiftRadix")
			]
		),
		
		// MIDIKit Sync submodule tests
		.testTarget(
			name: "MIDIKitSyncTests",
			dependencies: [
				.target(name: "MIDIKitTestsCommon"),
				.target(name: "MIDIKitSync"),
				.product(name: "TimecodeKit", package: "TimecodeKit")
			]
		)
		
	]
	
)
