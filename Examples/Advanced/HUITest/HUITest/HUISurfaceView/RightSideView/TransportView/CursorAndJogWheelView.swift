//
//  CursorAndJogWheelView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.RightSideView.TransportView {
    struct CursorAndJogWheelView: View {
        var body: some View {
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
                            )
                            .cornerRadius(30)
                            Spacer().frame(width: 40)
                        }
                        HStack {
                            HUIButton(
                                title: "◀︎",
                                param: .cursor(.left),
                                width: 40,
                                height: 40,
                                fontSize: 18
                            )
                            .cornerRadius(30)
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
                            )
                            .cornerRadius(30)
                        }
                        HStack {
                            Spacer().frame(width: 40)
                            HUIButton(
                                title: "▼",
                                param: .cursor(.down),
                                width: 40,
                                height: 40,
                                fontSize: 18
                            )
                            .cornerRadius(30)
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
                    }
                    .frame(width: 60)
                }
                
                Spacer().frame(width: 40)
            }
        }
    }
}
