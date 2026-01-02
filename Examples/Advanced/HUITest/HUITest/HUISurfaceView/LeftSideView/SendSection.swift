//
//  SendSection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.LeftSideView {
    struct SendSection: View {
        @Environment(HUISurface.self) var huiSurface
        
        var body: some View {
            VStack {
                HStack {
                    HUIStateButton(
                        title: "SEND A",
                        param: .assign(.sendA),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "REC/RDY ALL",
                        param: .assign(.recordReadyAll),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "SEND B",
                        param: .assign(.sendB),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "BYPASS",
                        param: .assign(.bypass),
                        ledColor: .green
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "SEND C",
                        param: .assign(.sendC),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "MUTE",
                        param: .assign(.mute),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "SEND D",
                        param: .assign(.sendD),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "SHIFT",
                        param: .assign(.shift),
                        ledColor: .red
                    )
                }
                HStack {
                    VStack {
                        HUIStateButton(
                            title: "SEND E",
                            param: .assign(.sendE),
                            ledColor: .red
                        )
                        HUIStateButton(
                            title: "PAN",
                            param: .assign(.pan),
                            ledColor: .yellow
                        )
                    }
                    
                    VStack {
                        Text("SELECT-ASSIGN")
                            .font(.system(size: 9))
                            .spaceHogFrame()
                        FourCharLCD(huiSurface.model.assign.textDisplay.stringValue)
                            .spaceHogFrame()
                    }
                }
                .frame(height: 65)
            }
            .frame(height: 220)
        }
    }
}
