//
//  MeterBridgeView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView {
    static let kMeterBridgeHeight: CGFloat = 100
}

extension HUISurfaceView {
    struct MeterBridgeView: View {
        var body: some View {
            HStack(alignment: .center, spacing: 1) {
                ForEach(0 ..< 7 + 1, id: \.self) { channel in
                    HStack(alignment: .center, spacing: 2) {
                        LevelMeterView(channel: channel, side: .left)
                            .frame(width: 10, height: HUISurfaceView.kMeterBridgeHeight)
                        LevelMeterView(channel: channel, side: .right)
                            .frame(width: 10, height: HUISurfaceView.kMeterBridgeHeight)
                    }
                    .frame(width: 40, height: HUISurfaceView.kMeterBridgeHeight, alignment: .center)
                    .border(Color.black)
                    .frame(width: 60)
                }
            }
        }
    }
    
    struct LevelMeterView: View {
        @Environment(HUISurface.self) var huiSurface

        let channel: Int
        let side: HUISurfaceModelState.StereoLevelMeterSide

        static let segmentIndexes = Array(
            stride(
                from: HUISurfaceModelState.StereoLevelMeterSide.levelMax,
                through: HUISurfaceModelState.StereoLevelMeterSide.levelMin + 1,
                by: -1
            )
        )

        var body: some View {
            VStack(alignment: .center, spacing: 1) {
                ForEach(Self.segmentIndexes, id: \.self) { segment in
                    Rectangle()
                        .fill(color(forSegment: segment))
                }
            }
            .background(Color(white: 0.25, opacity: 1.0))
        }

        func level() -> Int {
            huiSurface.model.channelStrips[channel].levelMeter.level(of: side)
        }

        func color(forSegment segment: Int) -> Color {
            segment <= level() ? segmentColor(segment) : Color.black
        }

        func segmentColor(_ segment: Int) -> Color {
            switch segment {
            case 0x1 ... 0x8: return .green
            case 0x9 ... 0xB: return .yellow
            case 0xC: return .red
            default: return .black
            }
        }
    }
}
