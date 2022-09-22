//
//  MeterBridgeView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    static let kMeterBridgeHeight: CGFloat = 100
}

extension HUISurfaceView {
    func MeterBridgeView() -> some View {
        HStack(alignment: .center, spacing: 1) {
            ForEach(0 ..< 7 + 1, id: \.self) { channel in
                HStack(alignment: .center, spacing: 2) {
                    LevelMeterView(channel: channel, side: .left)
                        .frame(width: 10, height: Self.kMeterBridgeHeight)
                    LevelMeterView(channel: channel, side: .right)
                        .frame(width: 10, height: Self.kMeterBridgeHeight)
                }
                .frame(width: 40, height: Self.kMeterBridgeHeight, alignment: .center)
                .border(Color.black)
                .frame(width: 60)
            }
        }
    }
    
    struct LevelMeterView: View {
        @EnvironmentObject var huiSurface: HUISurface

        let channel: Int
        let side: HUIModel.StereoLevelMeter.Side

        static let segmentIndexes = Array(
            stride(
                from: HUIModel.StereoLevelMeter.levelMax,
                through: HUIModel.StereoLevelMeter.levelMin + 1,
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
            segment < level() ? segmentColor(segment) : Color.black
        }

        func segmentColor(_ segment: Int) -> Color {
            switch segment {
            case 1 ... 8: return Color.green
            case 9 ... 11: return Color.yellow
            case 12: return Color.red
            default: return Color.black
            }
        }
    }
}
