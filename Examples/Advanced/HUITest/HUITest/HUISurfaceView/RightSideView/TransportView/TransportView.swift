//
//  TransportView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.RightSideView {
    struct TransportView: View {
        var body: some View {
            VStack {
                Spacer().frame(height: 10)
                SubTransportView()
                Spacer().frame(height: 10)
                MainTransportView()
                Spacer().frame(height: 20)
                CursorAndJogWheelView()
            }
        }
    }
}
