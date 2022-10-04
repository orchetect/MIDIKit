//
//  FKeysView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    func FKeysView() -> some View {
        HStack {
            Group {
                HUIStateButton(
                    title: "F1",
                    param: .functionKey(.f1),
                    ledColor: .red
                )
                HUIStateButton(
                    title: "F2",
                    param: .functionKey(.f2),
                    ledColor: .red
                )
                HUIStateButton(
                    title: "F3",
                    param: .functionKey(.f3),
                    ledColor: .red
                )
                HUIStateButton(
                    title: "F4",
                    param: .functionKey(.f4),
                    ledColor: .red
                )
                HUIStateButton(
                    title: "F5",
                    param: .functionKey(.f5),
                    ledColor: .red
                )
                HUIStateButton(
                    title: "F6",
                    param: .functionKey(.f6),
                    ledColor: .red
                )
                HUIStateButton(
                    title: "F7",
                    param: .functionKey(.f7),
                    ledColor: .red
                )
                HUIStateButton(
                    title: "F8/ESC",
                    param: .functionKey(.f8OrEsc),
                    ledColor: .red
                )
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}
