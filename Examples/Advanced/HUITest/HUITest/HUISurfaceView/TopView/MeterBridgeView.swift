//
//  MeterBridgeView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.TopView {
    struct MeterBridgeView: View {
        var body: some View {
            HStack(alignment: .center, spacing: 1) {
                ForEach(0 ..< 7 + 1, id: \.self) { channel in
                    HStack(alignment: .center, spacing: 2) {
                        LevelMeterView(channel: channel, side: .left)
                            .frame(width: 10, height: HUISurfaceView.TopView.kMeterBridgeHeight)
                        
                        LevelMeterView(channel: channel, side: .right)
                            .frame(width: 10, height: HUISurfaceView.TopView.kMeterBridgeHeight)
                    }
                    .frame(width: 40, height: HUISurfaceView.TopView.kMeterBridgeHeight, alignment: .center)
                    .border(Color.black)
                    .frame(width: 60)
                }
            }
        }
    }
}

// MARK: - Static

extension HUISurfaceView.TopView {
    static let kMeterBridgeHeight: CGFloat = 100
}
