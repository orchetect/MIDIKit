//
//  SubTransportView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.RightSideView.TransportView {
    struct SubTransportView: View {
        var body: some View {
            HStack {
                HStack {
                    VStack {
                        PlaceholderKnob(size: 30)
                        Text("LEVEL").font(.system(size: 10))
                    }
                    VStack {
                        Image(systemName: "circle.hexagongrid.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("MIC").font(.system(size: 10))
                    }
                }
                .frame(width: 70, height: 60)
                
                Spacer().frame(width: 40)
                
                VStack {
                    HStack {
                        Group {
                            HUIStateButton(
                                title: "AUDITION",
                                param: .transport(.punchAudition),
                                ledColor: .yellow,
                                fontSize: 9
                            )
                            HUIStateButton(
                                title: "PRE",
                                param: .transport(.punchPre),
                                ledColor: .yellow
                            )
                            HUIStateButton(
                                title: "IN",
                                param: .transport(.punchIn),
                                ledColor: .yellow
                            )
                            HUIStateButton(
                                title: "OUT",
                                param: .transport(.punchOut),
                                ledColor: .yellow
                            )
                            HUIStateButton(
                                title: "POST",
                                param: .transport(.punchPost),
                                ledColor: .yellow
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    HStack {
                        Group {
                            HUIStateButton(
                                image: Image(systemName: "backward.end.fill"),
                                // title: "|◀︎ RTZ",
                                param: .transport(.rtz),
                                ledColor: .yellow
                            )
                            HUIStateButton(
                                image: Image(systemName: "forward.end.fill"),
                                // title: "END ▶︎|",
                                param: .transport(.end),
                                ledColor: .yellow
                            )
                            HUIStateButton(
                                title: "ON LINE",
                                param: .transport(.online),
                                ledColor: .yellow
                            )
                            HUIStateButton(
                                image: Image(systemName: "repeat"),
                                // title: "LOOP",
                                param: .transport(.loop),
                                ledColor: .yellow
                            )
                            HUIStateButton(
                                title: "QUICK\nPUNCH",
                                param: .transport(.quickPunch),
                                ledColor: .yellow,
                                height: 30
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(width: 360, height: 60)
            }
        }
    }
}
