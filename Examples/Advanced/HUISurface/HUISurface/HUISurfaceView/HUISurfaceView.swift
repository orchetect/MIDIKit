//
//  HUISurfaceView.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

struct HUISurfaceView: View {
    @EnvironmentObject var huiSurface: MIDI.HUI.Surface
    
    var body: some View {
        VStack {
            TopView()
            Spacer().frame(height: 10)
            HStack {
                LeftSideView()
                Spacer().frame(width: 20)
                MixerView()
                Spacer().frame(width: 20)
                RightSideView()
            }
            .padding([.leading, .trailing])
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
