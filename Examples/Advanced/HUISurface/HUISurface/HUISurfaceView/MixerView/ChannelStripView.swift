//
//  ChannelStripView.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    static let channelStripWidth: CGFloat = 60
}

extension HUISurfaceView {
    struct ChannelStripView: View {
        @EnvironmentObject var huiSurface: MIDI.HUI.Surface
        
        let channel: Int
        
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
                    Text(huiSurface.state.channelStrips[channel].nameTextDisplay)
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
