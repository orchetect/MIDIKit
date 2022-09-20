//
//  LeftSideView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    static let kLeftSideViewWidth: CGFloat = 120
}

extension HUISurfaceView {
    func LeftSideView() -> some View {
        VStack {
            VStack {
                HStack {
                    HUIStateButton(
                        "SEND A",
                        .assign(.sendA),
                        .red
                    )
                    HUIStateButton(
                        "REC/RDY ALL",
                        .assign(.recordReadyAll),
                        .red
                    )
                }
                HStack {
                    HUIStateButton(
                        "SEND B",
                        .assign(.sendB),
                        .red
                    )
                    HUIStateButton(
                        "BYPASS",
                        .assign(.bypass),
                        .green
                    )
                }
                HStack {
                    HUIStateButton(
                        "SEND C",
                        .assign(.sendC),
                        .red
                    )
                    HUIStateButton(
                        "MUTE",
                        .assign(.mute),
                        .red
                    )
                }
                HStack {
                    HUIStateButton(
                        "SEND D",
                        .assign(.sendD),
                        .red
                    )
                    HUIStateButton(
                        "SHIFT",
                        .assign(.shift),
                        .red
                    )
                }
                HStack {
                    VStack {
                        HUIStateButton(
                            "SEND E",
                            .assign(.sendE),
                            .red
                        )
                        HUIStateButton(
                            "PAN",
                            .assign(.pan),
                            .yellow
                        )
                    }
                    
                    VStack {
                        Text("SELECT-ASSIGN").font(.system(size: 9))
                        Text(huiSurface.state.assign.textDisplay.stringValue)
                            .font(.system(size: 16, weight: .regular, design: .monospaced))
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity)
                            .frame(height: 26)
                            .background(Color.black)
                            .cornerRadius(3.0, antialiased: true)
                    }
                }
            }
            
            VStack {
                HStack {
                    Text("ASSIGN").font(.system(size: 10))
                    HUIStateButton(
                        "SUSPEND",
                        .assign(.suspend),
                        .red
                    )
                }
                HStack {
                    HUIStateButton(
                        "INPUT",
                        .assign(.input),
                        .red
                    )
                    HUIStateButton(
                        "DEFAULT",
                        .assign(.default),
                        .red
                    )
                }
                HStack {
                    HUIStateButton(
                        "OUTPUT",
                        .assign(.output),
                        .red
                    )
                    HUIStateButton(
                        "ASSIGN",
                        .assign(.assign),
                        .red
                    )
                }
            }
            
            VStack {
                HUISectionLabel("BANK")
                HStack {
                    HUIStateButton(
                        "◀︎",
                        .bankMove(.bankLeft),
                        .red
                    )
                    HUIStateButton(
                        "▶︎",
                        .bankMove(.bankRight),
                        .red
                    )
                }
                HUISectionLabel("CHANNEL")
                HStack {
                    HUIStateButton(
                        "◀︎",
                        .bankMove(.channelLeft),
                        .red
                    )
                    HUIStateButton(
                        "▶︎",
                        .bankMove(.channelRight),
                        .red
                    )
                }
            }
            
            VStack {
                HUISectionLabel("WINDOW")
                HStack {
                    HUIStateButton(
                        "TRANSPORT",
                        .window(.transport),
                        .red
                    )
                    HUIStateButton(
                        "ALT",
                        .window(.alt),
                        .red
                    )
                }
                HStack {
                    HUIStateButton(
                        "EDIT",
                        .window(.edit),
                        .red
                    )
                    HUIStateButton(
                        "STATUS",
                        .window(.status),
                        .red
                    )
                }
                HStack {
                    HUIStateButton(
                        "MIX",
                        .window(.mix),
                        .red
                    )
                    HUIStateButton(
                        "MEM-LOC",
                        .window(.memLoc),
                        .red
                    )
                }
            }
            
            VStack {
                HUISectionLabel("KEYBOARD SHORTCUTS")
                HStack {
                    HUIStateButton(
                        "UNDO",
                        .hotKey(.undo),
                        .green
                    )
                    HUIStateButton(
                        "SAVE",
                        .hotKey(.save),
                        .red
                    )
                }
                HStack {
                    HUIStateButton(
                        "EDIT MODE",
                        .hotKey(.editMode),
                        .green
                    )
                    HUIStateButton(
                        "EDIT TOOL",
                        .hotKey(.editTool),
                        .red
                    )
                }
                HStack {
                    HUIStateButton(
                        "SHIFT/ADD",
                        .hotKey(.shift),
                        .green
                    )
                    HUIStateButton(
                        "OPTION/ALT",
                        .hotKey(.option),
                        .red
                    )
                }
                HStack {
                    HUIStateButton(
                        "CTRL/CLUTCH",
                        .hotKey(.ctrl),
                        .green
                    )
                    HUIStateButton(
                        "⌘ALT/FINE",
                        .hotKey(.cmd),
                        .red
                    )
                }
            }
            
            Spacer()
        }
        .frame(width: Self.kLeftSideViewWidth, alignment: .top)
    }
}
