//
//  ChannelStripView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Controls
import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView {
    static let channelStripWidth: CGFloat = 58
}

extension HUISurfaceView {
    struct ChannelStripView: View {
        @EnvironmentObject var huiSurface: HUISurface
        
        let channel: UInt4
        
        var body: some View {
            VStack(alignment: .center, spacing: 10) {
                Group {
                    HUIStateButton(
                        title: "REC/RDY",
                        param: .channelStrip(channel, .recordReady),
                        ledColor: .red
                    )
                    
                    HUIStateButton(
                        title: "INSERT",
                        param: .channelStrip(channel, .insert),
                        ledColor: .green
                    )
                    
                    HUIStateButton(
                        title: "V-SEL",
                        param: .channelStrip(channel, .vPotSelect),
                        ledColor: .yellow
                    )
                }
                
                VStack(alignment: .center, spacing: 2) {
                    Text("PAN/SEND")
                        .font(.system(size: 9))
                    RotaryKnob(
                        label: "        ",
                        size: channelStripWidth,
                        vPot: .channel(channel)
                    )
                }
                
                Group {
                    HUIStateButton(
                        title: "AUTO",
                        param: .channelStrip(channel, .auto),
                        ledColor: .red
                    )
                    
                    HUIStateButton(
                        title: "SOLO",
                        param: .channelStrip(channel, .solo),
                        ledColor: .green
                    )
                    
                    HUIStateButton(
                        title: "MUTE",
                        param: .channelStrip(channel, .mute),
                        ledColor: .red
                    )
                }
                
                Group {
                    FourCharLCD(
                        huiSurface.model.channelStrips[channel.intValue].nameDisplay
                            .stringValue
                    )
                    
                    HUIStateButton(
                        title: "SELECT",
                        param: .channelStrip(channel, .select),
                        ledColor: .yellow
                    )
                    
                    FaderView(channel: channel)
                        .frame(height: 350)
                }
            }
        }
    }
}
