//
//  TransportView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

struct TransportView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            subTransportView
            Spacer().frame(height: 10)
            mainTransportView
            Spacer().frame(height: 20)
            cursorAndJogWheelView
        }
    }
    
    private var subTransportView: some View {
        HStack {
            HStack {
                VStack {
                    PlaceholderKnob(size: 30)
                    Text("LEVEL").font(.system(size: 10))
                }
                VStack {
                    Image(systemName: "circle.hexagongrid.circle")
                        .resizable()
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
    
    private var mainTransportView: some View {
        HStack {
            HStack {
                HUIStateButton(
                    image: Image(systemName: "mic.fill"),
                    title: "TALKBACK",
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
    
    private var cursorAndJogWheelView: some View {
        HStack {
            Spacer().frame(width: 40)
            
            HStack { // ▲▼◀︎▶︎
                VStack {
                    HStack {
                        Spacer().frame(width: 40)
                        HUIButton(
                            title: "▲",
                            param: .cursor(.up),
                            width: 40,
                            height: 40,
                            fontSize: 18
                        ).cornerRadius(30)
                        Spacer().frame(width: 40)
                    }
                    HStack {
                        HUIButton(
                            title: "◀︎",
                            param: .cursor(.left),
                            width: 40,
                            height: 40,
                            fontSize: 18
                        ).cornerRadius(30)
                        HUIStateButton(
                            title: "MODE",
                            param: .cursor(.mode),
                            ledColor: .red,
                            width: 40,
                            height: 30
                        )
                        HUIButton(
                            title: "▶︎",
                            param: .cursor(.right),
                            width: 40,
                            height: 40,
                            fontSize: 18
                        ).cornerRadius(30)
                    }
                    HStack {
                        Spacer().frame(width: 40)
                        HUIButton(
                            title: "▼",
                            param: .cursor(.down),
                            width: 40,
                            height: 40,
                            fontSize: 18
                        ).cornerRadius(30)
                        Spacer().frame(width: 40)
                    }
                }
            }
            .frame(width: 150)
            
            Spacer()
            
            JogWheel(size: 140)
            
            Spacer()
            
            HStack {
                VStack {
                    HUIStateButton(
                        title: "SCRUB",
                        param: .cursor(.scrub),
                        ledColor: .red
                    )
                    HUIStateButton(
                        title: "SHUTTLE",
                        param: .cursor(.shuttle),
                        ledColor: .red
                    )
                }.frame(width: 60)
            }
            
            Spacer().frame(width: 40)
        }
    }
}
