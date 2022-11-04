//
//  MainTimeDisplayView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

struct MainTimeDisplayView: View {
    @EnvironmentObject var huiSurface: HUISurface
        
    var body: some View {
        HStack {
            VStack(alignment: .trailing, spacing: 4) {
                Text(
                    "TIME CODE "
                        + (huiSurface.model.timeDisplay.timecode ? "🔴" : "⚪️")
                )
                Text(
                    "FEET "
                        + (huiSurface.model.timeDisplay.feet ? "🔴" : "⚪️")
                )
                Text(
                    "BEATS "
                        + (huiSurface.model.timeDisplay.beats ? "🔴" : "⚪️")
                )
            }
            .font(.system(size: 9, weight: .regular))
                
            Text(
                huiSurface.model.timeDisplay.timeString.stringValue
            )
            .font(.system(size: 20, weight: .regular, design: .monospaced))
            .foregroundColor(Color.red)
            .frame(width: 150, height: 30)
            .background(Color.black)
            .cornerRadius(3.0, antialiased: true)
                
            Spacer().frame(width: 20)
                
            HStack {
                VStack(alignment: .trailing, spacing: 1) {
                    Text("RUDE")
                    Text("SOLO")
                    Text("LIGHT")
                }
                .font(.system(size: 9, weight: .regular))
                    
                Text(huiSurface.model.timeDisplay.rudeSolo ? "🔴" : "⚪️")
                    .font(.system(size: 14))
            }
        }
    }
}
