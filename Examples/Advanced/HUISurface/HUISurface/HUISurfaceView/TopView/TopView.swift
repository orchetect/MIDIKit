//
//  TopView.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    func TopView() -> some View {
        VStack {
            HStack {
                Spacer()
                Text("hui")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .frame(width: Self.kLeftSideViewWidth)
                MeterBridgeView()
                LargeTextDisplayView()
                    .frame(width: Self.kRightSideViewWidth)
                Spacer()
            }
            .background(Color.black)
        }
    }
}
