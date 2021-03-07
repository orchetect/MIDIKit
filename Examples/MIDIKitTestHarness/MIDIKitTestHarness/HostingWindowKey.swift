//
//  HostingWindowKey.swift
//  MIDIKitTestHarness
//
//  Created by Steffan Andrews on 2021-02-26.
//

import SwiftUI

/// Allows accessing the hosting window object (`NSWindow`/`UIWindow`) from any subview by way of environment keypath.
///
/// Typical use:
///
///     class AppDelegate {
///       func applicationDidFinishLaunching(_ aNotification: Notification) {
///         // ...
///         let contentView = ContentView()
///           .environment(\.hostingWindow, { [weak window] in window })
///         // ...
///       }
///     }
///
///     struct ContentView: View {
///       @Environment(\.hostingWindow) var hostingWindow
///       Text(hostingWindow()?.title ?? "Default")
///     }
struct HostingWindowKey: EnvironmentKey {
	
	#if canImport(UIKit)
	typealias WrappedValue = UIWindow
	#elseif canImport(AppKit)
	typealias WrappedValue = NSWindow
	#else
	#error("Unsupported platform")
	#endif
	
	typealias Value = () -> WrappedValue? // needed for weak link
	
	static let defaultValue: Self.Value = { nil }
	
}

extension EnvironmentValues {
	
	/// Allows accessing the hosting window object (`NSWindow`/`UIWindow`) from any subview by way of environment keypath.
	///
	/// Typical use:
	///
	///     class AppDelegate {
	///       func applicationDidFinishLaunching(_ aNotification: Notification) {
	///         // ...
	///         let contentView = ContentView()
	///           .environment(\.hostingWindow, { [weak window] in window })
	///         // ...
	///       }
	///     }
	///
	///     struct ContentView: View {
	///       @Environment(\.hostingWindow) var hostingWindow
	///       Text(hostingWindow()?.title ?? "Default")
	///     }
	var hostingWindow: HostingWindowKey.Value {
		get {
			self[HostingWindowKey.self]
		}
		set {
			self[HostingWindowKey.self] = newValue
		}
	}
	
}
