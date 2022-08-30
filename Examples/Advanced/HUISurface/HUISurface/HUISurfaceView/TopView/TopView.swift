//
//  TopView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

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
