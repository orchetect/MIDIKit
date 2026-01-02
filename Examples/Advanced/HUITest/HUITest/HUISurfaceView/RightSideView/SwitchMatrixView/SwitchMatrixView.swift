//
//  SwitchMatrixView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.RightSideView {
    struct SwitchMatrixView: View {
        var body: some View {
            HStack {
                AutoEnableSection()
                HUISectionDivider(.vertical)
                AutoModeSection()
                HUISectionDivider(.vertical)
                StatusGroupSection()
                HUISectionDivider(.vertical)
                EditSection()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
        }
    }
}
