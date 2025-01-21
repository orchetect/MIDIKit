//
//  HUITestApp.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

@main
struct HUITestApp: App {
    @Environment(\.openWindow) private var openWindow
    
    @ObservedObject private var midiManager = ObservableMIDIManager(
        clientName: "HUITest",
        model: "HUITest",
        manufacturer: "MyCompany"
    )
    
    let huiHostWidth: CGFloat = 300
    let huiHostHeight: CGFloat = 600
    
    let huiSurfaceWidth: CGFloat = 1180
    let huiSurfaceHeight: CGFloat = 920
    
    init() {
        do {
            try midiManager.start()
        } catch {
            Logger.debug("Error setting up MIDI.")
        }
    }
    
    var body: some Scene {
        // Window("HUI Host", id: WindowID.huiHost) {
        //     HUIHostView(midiManager: midiManager)
        //         .frame(width: huiHostWidth, height: huiHostHeight)
        //         .environmentObject(midiManager)
        // }
        // .windowResizability(.contentSize)
        // .defaultPosition(UnitPoint(x: 0.25, y: 0.4))
        
        Window("HUI Surface", id: WindowID.huiSurface) {
            HUIClientView(midiManager: midiManager)
                .frame(width: huiSurfaceWidth, height: huiSurfaceHeight)
                .environmentObject(midiManager)
        }
        .windowResizability(.contentSize)
        .defaultPosition(UnitPoint(x: 0.5, y: 0.4))
        
        .onSceneBody {
            onAppLaunch()
        }
    }
    
    private func onAppLaunch() {
        // openWindow(id: WindowID.huiHost)
        openWindow(id: WindowID.huiSurface)
        
        orderAllWindowsFront()
    }
    
    private func orderAllWindowsFront() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
             NSApp.windows.forEach { $0.makeKeyAndOrderFront(self) }
        }
    }
}

enum WindowID {
    static let huiHost = "huiHost"
    static let huiSurface = "huiSurface"
}
