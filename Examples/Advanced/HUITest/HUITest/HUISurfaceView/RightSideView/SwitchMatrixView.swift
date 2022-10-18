//
//  SwitchMatrixView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    func SwitchMatrixView() -> some View {
        HStack {
            // AUTO ENABLE Section
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
            
            HUISectionDivider(.vertical)
            
            // AUTO MODE Section
            VStack {
                HUISectionLabel("AUTO MODE")
                HStack {
                    VStack {
                        HUIStateButton(
                            title: "READ",
                            param: .autoMode(.read),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "LATCH",
                            param: .autoMode(.latch),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "TRIM",
                            param: .autoMode(.trim),
                            ledColor: .yellow
                        )
                    }
                    VStack {
                        HUIStateButton(
                            title: "TOUCH",
                            param: .autoMode(.touch),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "WRITE",
                            param: .autoMode(.write),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "OFF",
                            param: .autoMode(.off),
                            ledColor: .yellow
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            HUISectionDivider(.vertical)
            
            // STATUS/GROUP Section
            VStack {
                HUISectionLabel("STATUS/GROUP")
                HStack {
                    VStack {
                        HUIStateButton(
                            title: "AUTO",
                            param: .statusAndGroup(.auto),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "MONITOR",
                            param: .statusAndGroup(.monitor),
                            ledColor: .yellow,
                            fontSize: 9
                        )
                        HUIStateButton(
                            title: "PHASE",
                            param: .statusAndGroup(.phase),
                            ledColor: .yellow
                        )
                    }
                    VStack {
                        HUIStateButton(
                            title: "GROUP",
                            param: .statusAndGroup(.group),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "CREATE",
                            param: .statusAndGroup(.create),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "SUSPEND",
                            param: .statusAndGroup(.suspend),
                            ledColor: .yellow,
                            fontSize: 9
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            HUISectionDivider(.vertical)
            
            // EDIT Section
            VStack {
                HUISectionLabel("EDIT")
                HStack {
                    VStack {
                        HUIStateButton(
                            title: "CAPTURE",
                            param: .edit(.capture),
                            ledColor: .yellow,
                            fontSize: 9
                        )
                        HUIStateButton(
                            title: "CUT",
                            param: .edit(.cut),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "PASTE",
                            param: .edit(.paste),
                            ledColor: .yellow
                        )
                    }
                    VStack {
                        HUIStateButton(
                            title: "SEPARATE",
                            param: .edit(.separate),
                            ledColor: .yellow,
                            fontSize: 8.5
                        )
                        HUIStateButton(
                            title: "COPY",
                            param: .edit(.copy),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "DELETE",
                            param: .edit(.delete),
                            ledColor: .yellow
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }
}
