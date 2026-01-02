//
//  KeyboardShortcutsSection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.LeftSideView {
    struct KeyboardShortcutsSection: View {
        var body: some View {
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
