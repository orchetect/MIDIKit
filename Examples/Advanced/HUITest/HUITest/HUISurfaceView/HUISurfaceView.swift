//
//  HUISurfaceView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

struct HUISurfaceView: View {
    @EnvironmentObject var huiSurface: HUISurface
    
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
