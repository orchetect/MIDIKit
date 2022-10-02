//
//  TransportView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    func TransportView() -> some View {
        VStack {
            Spacer().frame(height: 10)
            
            HStack {
                HStack {
                    VStack {
                        PlaceholderKnob(size: 30)
                        Text("LEVEL").font(.system(size: 10))
                    }
                    VStack {
                        Text("🎙").font(.system(size: 30))
                        Text("MIC").font(.system(size: 10))
                    }
                }
                .frame(width: 70, height: 60)
                
                Spacer().frame(width: 40)
                
                VStack {
                    HStack {
                        Group {
                            HUIStateButton(
                                "AUDITION",
                                .transport(.punchAudition),
                                .yellow,
                                fontSize: 9
                            )
                            HUIStateButton(
                                "PRE",
                                .transport(.punchPre),
                                .yellow
                            )
                            HUIStateButton(
                                "IN",
                                .transport(.punchIn),
                                .yellow
                            )
                            HUIStateButton(
                                "OUT",
                                .transport(.punchOut),
                                .yellow
                            )
                            HUIStateButton(
                                "POST",
                                .transport(.punchPost),
                                .yellow
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    HStack {
                        Group {
                            HUIStateButton(
                                "|◀︎ RTZ",
                                .transport(.rtz),
                                .yellow
                            )
                            HUIStateButton(
                                "END ▶︎|",
                                .transport(.end),
                                .yellow
                            )
                            HUIStateButton(
                                "ON LINE",
                                .transport(.online),
                                .yellow
                            )
                            HUIStateButton(
                                "LOOP",
                                .transport(.loop),
                                .yellow
                            )
                            HUIStateButton(
                                "QUICK PUNCH",
                                .transport(.quickPunch),
                                .yellow
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(width: 360, height: 60)
            }
            
            HStack {
                HStack {
                    HUIStateButton(
                        "TALKBACK\n🔊",
                        .transport(.talkback),
                        .red,
                        width: 60,
                        fontSize: 10
                    )
                }
                .frame(width: 70, height: 60)
                
                Spacer().frame(width: 40)
                
                HStack {
                    Group {
                        HUIStateButton(
                            "REWIND\n⏪",
                            .transport(.rewind),
                            .red,
                            width: 60,
                            fontSize: 11
                        )
                        
                        HUIStateButton(
                            "FAST FWD\n⏩",
                            .transport(.fastFwd),
                            .red,
                            width: 60,
                            fontSize: 11
                        )
                        
                        HUIStateButton(
                            "STOP\n⏹",
                            .transport(.stop),
                            .red,
                            width: 60,
                            fontSize: 11
                        )
                        
                        HUIStateButton(
                            "PLAY\n▶️",
                            .transport(.play),
                            .red,
                            width: 60,
                            fontSize: 11
                        )
                        
                        HUIStateButton(
                            "RECORD\n⏺",
                            .transport(.record),
                            .red,
                            width: 60,
                            fontSize: 11
                        )
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(width: 360, height: 60)
            }
            .frame(height: 40)
            
            Spacer().frame(height: 20)
            
            HStack {
                HStack { // ▲▼◀︎▶︎
                    VStack {
                        HStack {
                            Spacer().frame(width: 40)
                            HUIButton(
                                "▲",
                                .cursor(.up),
                                fontSize: 18
                            )
                            Spacer().frame(width: 40)
                        }
                        HStack {
                            HUIButton(
                                "◀︎",
                                .cursor(.left),
                                fontSize: 18
                            )
                            HUIStateButton(
                                "MODE",
                                .cursor(.mode),
                                .red
                            )
                            HUIButton(
                                "▶︎",
                                .cursor(.right),
                                fontSize: 18
                            )
                        }
                        HStack {
                            Spacer().frame(width: 40)
                            HUIButton(
                                "▼",
                                .cursor(.down),
                                fontSize: 18
                            )
                            Spacer().frame(width: 40)
                        }
                    }
                }
                
                Spacer().frame(width: 40)
                
                PlaceholderKnob(size: 140)
                
                Spacer().frame(width: 40)
                
                VStack {
                    HUIStateButton(
                        "SCRUB",
                        .cursor(.scrub),
                        .red
                    )
                    HUIStateButton(
                        "SHUTTLE",
                        .cursor(.shuttle),
                        .red
                    )
                }
            }
        }
    }
}
