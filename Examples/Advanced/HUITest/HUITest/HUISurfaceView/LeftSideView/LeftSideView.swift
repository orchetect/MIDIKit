//
//  LeftSideView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView {
    static let kLeftSideViewWidth: CGFloat = 120
}

extension HUISurfaceView {
    struct LeftSideView: View {
        @Environment(HUISurface.self) var huiSurface
        
        var body: some View {
            VStack {
                sendSection
                assignSection
                bankSection
                windowSection
                keyboardShortcutsSection
                Spacer()
            }
            .frame(width: HUISurfaceView.kLeftSideViewWidth, alignment: .top)
        }
        
        private var sendSection: some View {
            VStack {
                HStack {
                    HUIStateButton(
                        title: "SEND A",
                        param: .assign(.sendA),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "REC/RDY ALL",
                        param: .assign(.recordReadyAll),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "SEND B",
                        param: .assign(.sendB),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "BYPASS",
                        param: .assign(.bypass),
                        ledColor: .green
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "SEND C",
                        param: .assign(.sendC),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "MUTE",
                        param: .assign(.mute),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "SEND D",
                        param: .assign(.sendD),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "SHIFT",
                        param: .assign(.shift),
                        ledColor: .red
                    )
                }
                HStack {
                    VStack {
                        HUIStateButton(
                            title: "SEND E",
                            param: .assign(.sendE),
                            ledColor: .red
                        )
                        HUIStateButton(
                            title: "PAN",
                            param: .assign(.pan),
                            ledColor: .yellow
                        )
                    }
                    
                    VStack {
                        Text("SELECT-ASSIGN")
                            .font(.system(size: 9))
                            .spaceHogFrame()
                        FourCharLCD(huiSurface.model.assign.textDisplay.stringValue)
                            .spaceHogFrame()
                    }
                }
                .frame(height: 65)
            }
            .frame(height: 220)
        }
        
        private var assignSection: some View {
            VStack {
                HStack {
                    Text("ASSIGN")
                        .font(.system(size: 10))
                        .spaceHogFrame()
                    HUIStateButton(
                        title: "SUSPEND",
                        param: .assign(.suspend),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "INPUT",
                        param: .assign(.input),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "DEFAULT",
                        param: .assign(.default),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "OUTPUT",
                        param: .assign(.output),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "ASSIGN",
                        param: .assign(.assign),
                        ledColor: .red
                    )
                }
            }
            .frame(height: 100)
        }
        
        private var bankSection: some View {
            VStack {
                HUISectionLabel("BANK")
                HStack {
                    HUIStateButton(
                        title: "◀︎",
                        param: .bankMove(.bankLeft),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "▶︎",
                        param: .bankMove(.bankRight),
                        ledColor: .red
                    )
                }
                HUISectionLabel("CHANNEL")
                HStack {
                    HUIStateButton(
                        title: "◀︎",
                        param: .bankMove(.channelLeft),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "▶︎",
                        param: .bankMove(.channelRight),
                        ledColor: .red
                    )
                }
            }
            .frame(height: 100)
        }
        
        private var windowSection: some View {
            VStack {
                HUISectionLabel("WINDOW")
                HStack {
                    HUIStateButton(
                        title: "TRANS-PORT",
                        param: .window(.transport),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "ALT",
                        param: .window(.alt),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "EDIT",
                        param: .window(.edit),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "STATUS",
                        param: .window(.status),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "MIX",
                        param: .window(.mix),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "MEM-LOC",
                        param: .window(.memLoc),
                        ledColor: .red
                    )
                }
            }
            .frame(height: 140)
        }
        
        private var keyboardShortcutsSection: some View {
            VStack {
                HUISectionLabel("KEYBOARD SHORTCUTS")
                HStack {
                    HUIStateButton(
                        title: "UNDO",
                        param: .hotKey(.undo),
                        ledColor: .green
                    )
                    HUIStateButton(
                        title: "SAVE",
                        param: .hotKey(.save),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "EDIT MODE",
                        param: .hotKey(.editMode),
                        ledColor: .green
                    )
                    HUIStateButton(
                        title: "EDIT TOOL",
                        param: .hotKey(.editTool),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "SHIFT/ADD",
                        param: .hotKey(.shift),
                        ledColor: .green
                    )
                    HUIStateButton(
                        title: "OPTION/ALT",
                        param: .hotKey(.option),
                        ledColor: .red
                    )
                }
                HStack {
                    HUIStateButton(
                        title: "CTRL/CLUTCH",
                        param: .hotKey(.ctrl),
                        ledColor: .green
                    )
                    HUIStateButton(
                        title: "⌘ALT/FINE",
                        param: .hotKey(.cmd),
                        ledColor: .red
                    )
                }
            }
            .frame(height: 180)
        }
    }
}
