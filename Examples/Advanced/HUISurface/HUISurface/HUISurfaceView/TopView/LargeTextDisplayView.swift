//
//  LargeTextDisplayView.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension HUISurfaceView {
    func LargeTextDisplayView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            // Text(String(repeating: "0", count: 40))
            // Text(String(repeating: "0", count: 40))
            Text(huiSurface.state.largeDisplay.topStringValue)
            Text(huiSurface.state.largeDisplay.bottomStringValue)
        }
        .font(.system(size: 14, weight: .regular, design: .monospaced))
        .foregroundColor(Color.white)
        .frame(width: 360, height: 42)
        .background(Color.black)
        .cornerRadius(3.0, antialiased: true)
    }
}
