//
//  FaderView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import Combine
import MIDIKitControlSurfaces
import Controls

extension HUISurfaceView {
    struct FaderView: View {
        @EnvironmentObject var huiSurface: HUISurface

        static let faderHeight: CGFloat = 200
        static let faderWidth: CGFloat = 5
        static let faderCapsuleHeight: CGFloat = 40
        static let faderCapsuleWidth: CGFloat = 25

        let channel: UInt4

        @State private var isTouched = false
        @State private var level: Float = 0

        var body: some View {
            Fader(value: $level, isTouched: $isTouched)
                .foregroundColor(.gray)
                .backgroundColor(.black)
                .frame(minHeight: Self.faderHeight, alignment: .center)
                .padding([.leading, .trailing], 5)
                
                .onReceive(
                    Just(huiSurface.model.channelStrips[channel.intValue].fader.levelUnitInterval)
                ) { newValue in
                    // update fader level as result of received level from host
                    // but only if fader is not currently touched by user
                    guard !isTouched else { return }
                    level = Float(newValue)
                }
                .onChange(of: isTouched) { newValue in
                    // transmit touch state to host
                    newValue ? pressedAction() : releasedAction()
                }
                .onChange(of: level) { newValue in
                    // transmit level to host but only if fader is touched by user
                    // so as to avoid a feedback loop of transmitting back fader changes to the host
                    // that were originally made by inbound level messages from the host
                    guard isTouched else { return }
                    let rawLevel = UInt14(newValue * Float(UInt14.max))
                    huiSurface.transmitFader(level: rawLevel, channel: channel)
                }
        }

        private func pressedAction() {
            huiSurface.transmitSwitch(.channelStrip(channel, .faderTouched), state: true)
        }

        private func releasedAction() {
            huiSurface.transmitSwitch(.channelStrip(channel, .faderTouched), state: false)
        }
    }
}
