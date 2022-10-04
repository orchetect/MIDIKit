//
//  ParameterEditAssignView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    /// "DSP EDIT/ASSIGN" Section
    func ParameterEditAssignView() -> some View {
        HStack(alignment: .top, spacing: nil) {
            Group {
                VStack {
                    HUIStateButton(
                        "ASSIGN",
                        .paramEdit(.assign),
                        .green
                    )
                    HUIStateButton(
                        "COMPARE",
                        .paramEdit(.compare),
                        .green,
                        fontSize: 8.5
                    )
                    HUIStateButton(
                        "BYPASS",
                        .paramEdit(.bypass),
                        .green
                    )
                }
                
                HStack {
                    HUISectionDivider(.vertical)
                    
                    // Param 1
                    VStack {
                        HUIStateButton(
                            "SELECT",
                            .paramEdit(.param1Select),
                            .green
                        )
                        RotaryKnob(
                            label: "        ",
                            size: 40,
                            vPot: .editAssignA
                        )
                    }
                    .frame(width: 75)
                    
                    HUISectionDivider(.vertical)
                    
                    // Param 2
                    VStack {
                        HUIStateButton(
                            "SELECT",
                            .paramEdit(.param2Select),
                            .green
                        )
                        RotaryKnob(
                            label: "        ",
                            size: 40,
                            vPot: .editAssignB
                        )
                    }
                    .frame(width: 75)
                    
                    HUISectionDivider(.vertical)
                    
                    // Param 3
                    VStack {
                        HUIStateButton(
                            "SELECT",
                            .paramEdit(.param3Select),
                            .green
                        )
                        RotaryKnob(
                            label: "        ",
                            size: 40,
                            vPot: .editAssignC
                        )
                    }
                    .frame(width: 75)
                    
                    HUISectionDivider(.vertical)
                    
                    // Param 4
                    VStack {
                        HUIStateButton(
                            "SELECT",
                            .paramEdit(.param4Select),
                            .green
                        )
                        RotaryKnob(
                            label: "        ",
                            size: 40,
                            vPot: .editAssignD
                        )
                    }
                    .frame(width: 75)
                    
                    HUISectionDivider(.vertical)
                }
                
                VStack {
                    HUIStateButton(
                        "INSERT ○\nPARAM ●",
                        .paramEdit(.insertOrParam),
                        .green,
                        width: 60
                    )
                    RotaryKnob(
                        label: "",
                        size: 20,
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
