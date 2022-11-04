//
//  ParameterEditAssignView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

/// "DSP EDIT/ASSIGN" Section
struct ParameterEditAssignView: View {
    var body: some View {
        HStack(alignment: .top, spacing: nil) {
            Group {
                VStack {
                    HUIStateButton(
                        title: "ASSIGN",
                        param: .paramEdit(.assign),
                        ledColor: .green
                    )
                    HUIStateButton(
                        title: "COMPARE",
                        param: .paramEdit(.compare),
                        ledColor: .green,
                        fontSize: 8.5
                    )
                    HUIStateButton(
                        title: "BYPASS",
                        param: .paramEdit(.bypass),
                        ledColor: .green
                    )
                }
                    
                HStack {
                    HUISectionDivider(.vertical)
                        
                    // Param 1
                    VStack {
                        HUIStateButton(
                            title: "SELECT",
                            param: .paramEdit(.param1Select),
                            ledColor: .green
                        )
                        RotaryKnob(
                            label: "        ",
                            size: HUISurfaceView.channelStripWidth,
                            vPot: .editAssignA
                        )
                    }
                    .frame(width: 75)
                        
                    HUISectionDivider(.vertical)
                        
                    // Param 2
                    VStack {
                        HUIStateButton(
                            title: "SELECT",
                            param: .paramEdit(.param2Select),
                            ledColor: .green
                        )
                        RotaryKnob(
                            label: "        ",
                            size: HUISurfaceView.channelStripWidth,
                            vPot: .editAssignB
                        )
                    }
                    .frame(width: 75)
                        
                    HUISectionDivider(.vertical)
                        
                    // Param 3
                    VStack {
                        HUIStateButton(
                            title: "SELECT",
                            param: .paramEdit(.param3Select),
                            ledColor: .green
                        )
                        RotaryKnob(
                            label: "        ",
                            size: HUISurfaceView.channelStripWidth,
                            vPot: .editAssignC
                        )
                    }
                    .frame(width: 75)
                        
                    HUISectionDivider(.vertical)
                        
                    // Param 4
                    VStack {
                        HUIStateButton(
                            title: "SELECT",
                            param: .paramEdit(.param4Select),
                            ledColor: .green
                        )
                        RotaryKnob(
                            label: "        ",
                            size: HUISurfaceView.channelStripWidth,
                            vPot: .editAssignD
                        )
                    }
                    .frame(width: 75)
                        
                    HUISectionDivider(.vertical)
                }
                    
                VStack {
                    HUIStateButton(
                        title: "INSERT ○\nPARAM ●",
                        param: .paramEdit(.insertOrParam),
                        ledColor: .green,
                        height: 30
                    )
                    RotaryKnob(
                        label: "",
                        size: HUISurfaceView.channelStripWidth / 2,
                        vPot: .editAssignScroll
                    )
                    Text("SCROLL")
                        .font(.system(size: 9))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
    }
}
