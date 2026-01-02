//
//  MainTransportView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.RightSideView.TransportView {
    struct MainTransportView: View {
        var body: some View {
            HStack {
                HStack {
                    HUIStateButton(
                        title: "TALKBACK",
                        image: Image(systemName: "mic.fill"),
                        param: .transport(.talkback),
                        ledColor: .red,
                        width: 60,
                        fontSize: 10
                    )
                }
                .frame(width: 70, height: 40)
                
                Spacer().frame(width: 40)
                
                HStack {
                    Group {
                        HUIStateButton(
                            image: Image(systemName: "backward.fill"),
                            // title: "REWIND",
                            param: .transport(.rewind),
                            ledColor: .red,
                            width: 60,
                            fontSize: 11
                        )
                        
                        HUIStateButton(
                            image: Image(systemName: "forward.fill"),
                            // title: "FAST FWD",
                            param: .transport(.fastFwd),
                            ledColor: .red,
                            width: 60,
                            fontSize: 11
                        )
                        
                        HUIStateButton(
                            image: Image(systemName: "stop.fill"),
                            // title: "STOP",
                            param: .transport(.stop),
                            ledColor: .red,
                            width: 60,
                            fontSize: 11
                        )
                        
                        HUIStateButton(
                            image: Image(systemName: "play.fill"),
                            // title: "PLAY",
                            param: .transport(.play),
                            ledColor: .red,
                            width: 60,
                            fontSize: 11
                        )
                        
                        HUIStateButton(
                            image: Image(systemName: "record.circle.fill"),
                            // title: "RECORD",
                            param: .transport(.record),
                            ledColor: .red,
                            width: 60,
                            fontSize: 11
                        )
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(width: 360, height: 40)
            }
            .frame(height: 40)
        }
    }
}
