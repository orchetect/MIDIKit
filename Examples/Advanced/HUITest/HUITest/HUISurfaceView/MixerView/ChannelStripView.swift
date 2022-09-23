//
//  ChannelStripView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    static let channelStripWidth: CGFloat = 60
}

extension HUISurfaceView {
    struct ChannelStripView: View {
        @EnvironmentObject var huiSurface: HUISurface
        
        let channel: UInt4
        
        var body: some View {
            VStack(alignment: .center, spacing: 10) {
                Group {
                    HUIStateButton(
                        "REC/RDY",
                        .channelStrip(channel, .recordReady),
                        .red
                    )
                    
                    HUIStateButton(
                        "INSERT",
                        .channelStrip(channel, .insert),
                        .green
                    )
                    
                    HUIStateButton(
                        "V-SEL",
                        .channelStrip(channel, .vPotSelect),
                        .yellow
                    )
                }
                
                VStack(alignment: .center, spacing: 2) {
                    Text("PAN/SEND")
                        .font(.system(size: 9))
                    RotaryKnob(size: 40)
                }
                
                Group {
                    HUIStateButton(
                        "AUTO",
                        .channelStrip(channel, .auto),
                        .red
                    )
                    
                    HUIStateButton(
                        "SOLO",
                        .channelStrip(channel, .solo),
                        .green
                    )
                    
                    HUIStateButton(
                        "MUTE",
                        .channelStrip(channel, .mute),
                        .red
                    )
                }
                
                Group {
                    Text(
                        huiSurface.model.channelStrips[channel.intValue].nameDisplay
                            .stringValue
                    )
                    .font(.system(size: 16, weight: .regular, design: .monospaced))
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .frame(height: 26)
                    .background(Color.black)
                    .cornerRadius(3.0, antialiased: true)
                    
                    HUIStateButton(
                        "SELECT",
                        .channelStrip(channel, .select),
                        .yellow
                    )
                    
                    FaderView(channel: channel)
                }
            }
        }
    }
}
