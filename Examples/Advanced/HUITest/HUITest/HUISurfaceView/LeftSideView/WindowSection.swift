//
//  WindowSection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.LeftSideView {
    struct WindowSection: View {
        var body: some View {
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
    }
}
