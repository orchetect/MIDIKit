//
//  MixerView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension HUISurfaceView {
    func MixerView() -> some View {
        VStack {
            HStack(alignment: .center, spacing: 1) {
                ForEach(0 ..< 7 + 1, id: \.self) { channel in
                    ChannelStripView(channel: channel)
                        .frame(width: Self.channelStripWidth, alignment: .center)
                }
            }
            Spacer()
        }
    }
}
