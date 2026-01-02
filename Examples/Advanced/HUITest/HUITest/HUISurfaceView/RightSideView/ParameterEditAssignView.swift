//
//  ParameterEditAssignView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.RightSideView {
    /// "DSP EDIT/ASSIGN" Section
    struct ParameterEditAssignView: View {
        var body: some View {
            HStack(alignment: .top) {
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
                            size: HUISurfaceView.MixerView.channelStripWidth,
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
                            size: HUISurfaceView.MixerView.channelStripWidth,
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
                            size: HUISurfaceView.MixerView.channelStripWidth,
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
                            size: HUISurfaceView.MixerView.channelStripWidth,
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
                        size: HUISurfaceView.MixerView.channelStripWidth / 2,
                        vPot: .editAssignScroll
                    )
                    Text("SCROLL")
                        .font(.system(size: 9))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
        }
    }
}
