//
//  SwitchMatrixView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

struct SwitchMatrixView: View {
    var body: some View {
        HStack {
            autoEnableSection
            HUISectionDivider(.vertical)
            autoModeSection
            HUISectionDivider(.vertical)
            statusGroupSection
            HUISectionDivider(.vertical)
            editSection
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
    }
        
    private var autoEnableSection: some View {
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
        
    private var autoModeSection: some View {
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
    }
        
    private var statusGroupSection: some View {
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
    }
        
    private var editSection: some View {
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
}
