//
//  HUISurfaceView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

struct HUISurfaceView: View {
    @Environment(HUISurface.self) var huiSurface
    
    var body: some View {
        VStack {
            TopView()
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                LeftSideView()
                
                Spacer()
                    .frame(width: 20)
                
                MixerView()
                
                Spacer()
                    .frame(width: 20)
                
                RightSideView()
            }
            .padding([.leading, .trailing])
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
