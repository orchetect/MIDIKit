//
//  FKeysView.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    func FKeysView() -> some View {
        HStack {
            Group {
                HUIStateButton(
                    "F1",
                    .functionKey(.f1),
                    .red
                )
                HUIStateButton(
                    "F2",
                    .functionKey(.f2),
                    .red
                )
                HUIStateButton(
                    "F3",
                    .functionKey(.f3),
                    .red
                )
                HUIStateButton(
                    "F4",
                    .functionKey(.f4),
                    .red
                )
                HUIStateButton(
                    "F5",
                    .functionKey(.f5),
                    .red
                )
                HUIStateButton(
                    "F6",
                    .functionKey(.f6),
                    .red
                )
                HUIStateButton(
                    "F7",
                    .functionKey(.f7),
                    .red
                )
                HUIStateButton(
                    "F8/ESC",
                    .functionKey(.f8OrEsc),
                    .red
                )
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}
