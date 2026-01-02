//
//  LeftSideView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView {
    struct LeftSideView: View {
        var body: some View {
            VStack {
                SendSection()
                AssignSection()
                BankSection()
                WindowSection()
                KeyboardShortcutsSection()
                Spacer()
            }
            .frame(width: HUISurfaceView.kLeftSideViewWidth, alignment: .top)
        }
    }
}

// MARK: - Static

extension HUISurfaceView {
    static let kLeftSideViewWidth: CGFloat = 120
}
