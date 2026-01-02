//
//  HUIClientView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import MIDIKitIO
import SwiftUI

struct HUIClientView: View {
    @Environment(MIDIHelper.self) private var midiHelper
    
    @State private var huiClientHelper: HUIClientHelper = HUIClientHelper()
    
    init() { }
    
    var body: some View {
        HUISurfaceView()
            .frame(maxWidth: .infinity)
            .environment(huiClientHelper.huiSurface)
            .task {
                await huiClientHelper.setup(midiManager: midiHelper.midiManager)
                await huiClientHelper.startVirtualPorts()
            }
            .onDisappear { huiClientHelper.stopVirtualPorts() }
    }
}
