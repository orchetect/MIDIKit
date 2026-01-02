//
//  AutoEnableSection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.RightSideView.SwitchMatrixView {
    struct AutoEnableSection: View {
        var body: some View {
            VStack {
                HUISectionLabel("AUTO ENABLE")
                
                HStack {
                    VStack {
                        HUIStateButton(
                            title: "FADER",
                            param: .autoEnable(.fader),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "PAN",
                            param: .autoEnable(.pan),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "PLUG IN",
                            param: .autoEnable(.plugin),
                            ledColor: .yellow
                        )
                    }
                    VStack {
                        HUIStateButton(
                            title: "MUTE",
                            param: .autoEnable(.mute),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "SEND",
                            param: .autoEnable(.send),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "SEND MUTE",
                            param: .autoEnable(.sendMute),
                            ledColor: .yellow,
                            fontSize: 7
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
