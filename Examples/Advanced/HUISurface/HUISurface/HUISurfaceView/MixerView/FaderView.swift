//
//  FaderView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    struct FaderView: View {
        @EnvironmentObject var huiSurface: HUISurface

        static let faderHeight: CGFloat = 200
        static let faderWidth: CGFloat = 5
        static let faderCapsuleHeight: CGFloat = 40
        static let faderCapsuleWidth: CGFloat = 25

        let channel: Int

        @State private var isPressed = false

        var body: some View {
            let pos = CGFloat(huiSurface.state.channelStrips[channel].fader.levelUnitInterval)

            ZStack {
                Rectangle()
                    .frame(width: Self.faderWidth, height: Self.faderHeight, alignment: .center)
                    .background(Color.black)

                VStack(alignment: .center, spacing: 0) {
                    Spacer(minLength: 0)
                    Rectangle()
                        .frame(
                            width: Self.faderCapsuleWidth,
                            height: Self.faderCapsuleHeight,
                            alignment: .center
                        )
                        .background(Color.gray)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if !isPressed {
                                        pressedAction()
                                        isPressed = true
                                        return
                                    }
                                    // TODO: finish SwiftUI HUI fader
                                }
                                .onEnded { _ in
                                    releasedAction()
                                    isPressed = false
                                }
                        )
                    Spacer()
                        .frame(height: pos * (Self.faderHeight - Self.faderCapsuleHeight))
                }
                .frame(height: Self.faderHeight, alignment: .center)
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
