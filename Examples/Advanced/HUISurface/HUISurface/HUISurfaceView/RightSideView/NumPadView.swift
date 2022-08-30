//
//  NumPadView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    func NumPadView() -> some View {
        Group {
            let numPadSpacing: CGFloat = 1
            
            VStack {
                HUISectionLabel("LOCATE/NUMERICS")
                
                VStack(alignment: .center, spacing: numPadSpacing) {
                    HStack(alignment: .center, spacing: numPadSpacing) {
                        HUINumPadButton(
                            "CLR",
                            .numPad(.clr)
                        )
                        HUINumPadButton(
                            "=",
                            .numPad(.equals)
                        )
                        HUINumPadButton(
                            "/",
                            .numPad(.forwardSlash)
                        )
                        HUINumPadButton(
                            "*",
                            .numPad(.asterisk)
                        )
                    }
                    
                    HStack(alignment: .center, spacing: numPadSpacing) {
                        HUINumPadButton(
                            "7",
                            .numPad(.num7)
                        )
                        HUINumPadButton(
                            "8",
                            .numPad(.num8)
                        )
                        HUINumPadButton(
                            "9",
                            .numPad(.num9)
                        )
                        HUINumPadButton(
                            "-",
                            .numPad(.minus)
                        )
                    }
                    
                    HStack(alignment: .center, spacing: numPadSpacing) {
                        HUINumPadButton(
                            "4",
                            .numPad(.num4)
                        )
                        HUINumPadButton(
                            "5",
                            .numPad(.num5)
                        )
                        HUINumPadButton(
                            "6",
                            .numPad(.num6)
                        )
                        HUINumPadButton(
                            "+",
                            .numPad(.plus)
                        )
                    }
                    
                    HStack(alignment: .center, spacing: numPadSpacing) {
                        VStack(alignment: .center, spacing: numPadSpacing) {
                            HStack(alignment: .center, spacing: numPadSpacing) {
                                HUINumPadButton(
                                    "1",
                                    .numPad(.num1)
                                )
                                HUINumPadButton(
                                    "2",
                                    .numPad(.num2)
                                )
                                HUINumPadButton(
                                    "3",
                                    .numPad(.num3)
                                )
                            }
                            HStack(alignment: .center, spacing: numPadSpacing) {
                                HUINumPadButton(
                                    "0",
                                    .numPad(.num0),
                                    spacing: numPadSpacing,
                                    widthScale: 2
                                )
                                HUINumPadButton(
                                    ".",
                                    .numPad(.period)
                                )
                            }
                        }
                        HUINumPadButton(
                            "E\nN\nT\nE\nR",
                            .numPad(.enter),
                            spacing: numPadSpacing,
                            heightScale: 2,
                            fontSize: 12
                        )
                    }
                }
            }
        }
    }
}
