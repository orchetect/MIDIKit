//
//  LevelMeterView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.TopView.MeterBridgeView {
    struct LevelMeterView: View {
        @Environment(HUISurface.self) var huiSurface
        
        let channel: Int
        let side: HUISurfaceModelState.StereoLevelMeterSide
        
        var body: some View {
            VStack(alignment: .center, spacing: 1) {
                ForEach(Self.segmentIndexes, id: \.self) { segment in
                    Rectangle()
                        .fill(color(forSegment: segment))
                }
            }
            .background(Color(white: 0.25, opacity: 1.0))
        }
    }
}

// MARK: - Static

extension HUISurfaceView.TopView.MeterBridgeView.LevelMeterView {
    static let segmentIndexes = Array(
        stride(
            from: HUISurfaceModelState.StereoLevelMeterSide.levelMax,
            through: HUISurfaceModelState.StereoLevelMeterSide.levelMin + 1,
            by: -1
        )
    )
}

// MARK: - ViewModel

extension HUISurfaceView.TopView.MeterBridgeView.LevelMeterView {
    func level() -> Int {
        huiSurface.model.channelStrips[channel].levelMeter.level(of: side)
    }
    
    func color(forSegment segment: Int) -> Color {
        segment <= level() ? segmentColor(segment) : Color.black
    }
    
    func segmentColor(_ segment: Int) -> Color {
        switch segment {
        case 0x1 ... 0x8: .green
        case 0x9 ... 0xB: .yellow
        case 0xC: .red
        default: .black
        }
    }
}
