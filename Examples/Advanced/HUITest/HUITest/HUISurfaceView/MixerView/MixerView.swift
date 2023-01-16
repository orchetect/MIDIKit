//
//  MixerView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension HUISurfaceView {
    struct MixerView: View {
        var body: some View {
            VStack {
                HStack(alignment: .center, spacing: 3) {
                    ForEach(0 ..< 7 + 1, id: \.self) { channel in
                        ChannelStripView(channel: channel.toUInt4)
                            .frame(width: HUISurfaceView.channelStripWidth, alignment: .center)
                    }
                }
                Spacer()
            }
        }
    }
}
