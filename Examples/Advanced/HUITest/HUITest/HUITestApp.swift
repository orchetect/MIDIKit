//
//  HUITestApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

@main
struct HUITestApp: App {
    @Environment(\.openWindow) private var openWindow
    
    @State private var midiHelper = MIDIHelper(start: true)
    
    var body: some Scene {
        Window("HUI Host", id: WindowID.huiHost) {
            HUIHostView()
                .frame(width: huiHostWidth, height: huiHostHeight)
                .environment(midiHelper)
        }
        .windowResizability(.contentSize)
        .defaultPosition(UnitPoint(x: 0.25, y: 0.4))
        
        Window("HUI Surface", id: WindowID.huiSurface) {
            HUIClientView()
                .frame(width: huiSurfaceWidth, height: huiSurfaceHeight)
                .environment(midiHelper)
        }
        .windowResizability(.contentSize)
        .defaultPosition(UnitPoint(x: 0.5, y: 0.4))
        
        .onSceneBody {
            onAppLaunch()
        }
    }
}

// MARK: - Static

extension HUITestApp {
    var huiHostWidth: CGFloat { 300 }
    var huiHostHeight: CGFloat { 600 }
    
    var huiSurfaceWidth: CGFloat { 1180 }
    var huiSurfaceHeight: CGFloat { 920 }
}

// MARK: - ViewModel

extension HUITestApp {
    private func onAppLaunch() {
        openWindow(id: WindowID.huiHost)
        openWindow(id: WindowID.huiSurface)
        
        orderAllWindowsFront()
    }
    
    private func orderAllWindowsFront() {
        Task { @MainActor in
            try await Task.sleep(for: .milliseconds(500))
            NSApp.windows.forEach { $0.makeKeyAndOrderFront(self) }
        }
    }
}
