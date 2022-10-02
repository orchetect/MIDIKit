//
//  FaderView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
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
                .foregroundColor(.black)
                .backgroundColor(.gray)
                .frame(minHeight: Self.faderHeight, alignment: .center)
                .padding([.leading, .trailing], 5)
            
                .onChange(of: isTouched) { newValue in
                    newValue ? pressedAction() : releasedAction()
                }
                .onChange(
                    of: huiSurface.model
                        .channelStrips[channel.intValue]
                        .fader
                        .levelUnitInterval
                ) { newValue in
                    guard !isTouched else { return }
                    level = Float(newValue)
                }
                .onChange(of: level) { newValue in
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
