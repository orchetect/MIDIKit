//
//  NumPadView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
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
                            title: "CLR",
                            param: .numPad(.clr)
                        )
                        HUINumPadButton(
                            title: "=",
                            param: .numPad(.equals)
                        )
                        HUINumPadButton(
                            title: "/",
                            param: .numPad(.forwardSlash)
                        )
                        HUINumPadButton(
                            title: "*",
                            param: .numPad(.asterisk)
                        )
                    }
                    
                    HStack(alignment: .center, spacing: numPadSpacing) {
                        HUINumPadButton(
                            title: "7",
                            param: .numPad(.num7)
                        )
                        HUINumPadButton(
                            title: "8",
                            param: .numPad(.num8)
                        )
                        HUINumPadButton(
                            title: "9",
                            param: .numPad(.num9)
                        )
                        HUINumPadButton(
                            title: "-",
                            param: .numPad(.minus)
                        )
                    }
                    
                    HStack(alignment: .center, spacing: numPadSpacing) {
                        HUINumPadButton(
                            title: "4",
                            param: .numPad(.num4)
                        )
                        HUINumPadButton(
                            title: "5",
                            param: .numPad(.num5)
                        )
                        HUINumPadButton(
                            title: "6",
                            param: .numPad(.num6)
                        )
                        HUINumPadButton(
                            title: "+",
                            param: .numPad(.plus)
                        )
                    }
                    
                    HStack(alignment: .center, spacing: numPadSpacing) {
                        VStack(alignment: .center, spacing: numPadSpacing) {
                            HStack(alignment: .center, spacing: numPadSpacing) {
                                HUINumPadButton(
                                    title: "1",
                                    param: .numPad(.num1)
                                )
                                HUINumPadButton(
                                    title: "2",
                                    param: .numPad(.num2)
                                )
                                HUINumPadButton(
                                    title: "3",
                                    param: .numPad(.num3)
                                )
                            }
                            HStack(alignment: .center, spacing: numPadSpacing) {
                                HUINumPadButton(
                                    title: "0",
                                    param: .numPad(.num0),
                                    spacing: numPadSpacing,
                                    widthScale: 2
                                )
                                HUINumPadButton(
                                    title: ".",
                                    param: .numPad(.period)
                                )
                            }
                        }
                        HUINumPadButton(
                            title: "E\nN\nT\nE\nR",
                            param: .numPad(.enter),
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
