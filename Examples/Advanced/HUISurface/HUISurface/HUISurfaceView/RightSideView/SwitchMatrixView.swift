//
//  SwitchMatrixView.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
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
                            "FADER",
                            .autoEnable(.fader),
                            .yellow
                        )
                        HUIStateButton(
                            "PAN",
                            .autoEnable(.pan),
                            .yellow
                        )
                        HUIStateButton(
                            "PLUG IN",
                            .autoEnable(.plugin),
                            .yellow
                        )
                    }
                    VStack {
                        HUIStateButton(
                            "MUTE",
                            .autoEnable(.mute),
                            .yellow
                        )
                        HUIStateButton(
                            "SEND",
                            .autoEnable(.send),
                            .yellow
                        )
                        HUIStateButton(
                            "SEND MUTE",
                            .autoEnable(.sendMute),
                            .yellow,
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
                            "READ",
                            .autoMode(.read),
                            .yellow
                        )
                        HUIStateButton(
                            "LATCH",
                            .autoMode(.latch),
                            .yellow
                        )
                        HUIStateButton(
                            "TRIM",
                            .autoMode(.trim),
                            .yellow
                        )
                    }
                    VStack {
                        HUIStateButton(
                            "TOUCH",
                            .autoMode(.touch),
                            .yellow
                        )
                        HUIStateButton(
                            "WRITE",
                            .autoMode(.write),
                            .yellow
                        )
                        HUIStateButton(
                            "OFF",
                            .autoMode(.off),
                            .yellow
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
                            "AUTO",
                            .statusAndGroup(.auto),
                            .yellow
                        )
                        HUIStateButton(
                            "MONITOR",
                            .statusAndGroup(.monitor),
                            .yellow,
                            fontSize: 9
                        )
                        HUIStateButton(
                            "PHASE",
                            .statusAndGroup(.phase),
                            .yellow
                        )
                    }
                    VStack {
                        HUIStateButton(
                            "GROUP",
                            .statusAndGroup(.group),
                            .yellow
                        )
                        HUIStateButton(
                            "CREATE",
                            .statusAndGroup(.create),
                            .yellow
                        )
                        HUIStateButton(
                            "SUSPEND",
                            .statusAndGroup(.suspend),
                            .yellow,
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
                            "CAPTURE",
                            .edit(.capture),
                            .yellow,
                            fontSize: 9
                        )
                        HUIStateButton(
                            "CUT",
                            .edit(.cut),
                            .yellow
                        )
                        HUIStateButton(
                            "PASTE",
                            .edit(.paste),
                            .yellow
                        )
                    }
                    VStack {
                        HUIStateButton(
                            "SEPARATE",
                            .edit(.separate),
                            .yellow,
                            fontSize: 8.5
                        )
                        HUIStateButton(
                            "COPY",
                            .edit(.copy),
                            .yellow
                        )
                        HUIStateButton(
                            "DELETE",
                            .edit(.delete),
                            .yellow
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
