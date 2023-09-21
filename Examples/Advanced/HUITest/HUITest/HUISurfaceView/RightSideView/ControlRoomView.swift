//
//  ControlRoomView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

struct ControlRoomView: View {
    var body: some View {
        HStack {
            VStack {
                HUIStateButton(
                    title: "INPUT 1",
                    param: .controlRoom(.input1),
                    ledColor: .green,
                    height: 30
                )
                HUIStateButton(
                    title: "INPUT 2",
                    param: .controlRoom(.input2),
                    ledColor: .green,
                    height: 30
                )
                HUIStateButton(
                    title: "INPUT 3",
                    param: .controlRoom(.input3),
                    ledColor: .green,
                    height: 30
                )
            }
            .spaceHogFrame()
                
            VStack {
                HStack {
                    HUIStateButton(
                        title: "1:1 DISCRETE",
                        param: .controlRoom(.discreteInput1to1),
                        ledColor: .red,
                        height: 30,
                        fontSize: 9
                    )
                    HUIStateButton(
                        title: "MONO",
                        param: .controlRoom(.mono),
                        ledColor: .red,
                        height: 30
                    )
                }
                    
                PlaceholderKnob(size: 50)
                Text("MASTER VOLUME").font(.system(size: 10))
                    
                HStack {
                    HUIStateButton(
                        title: "MUTE",
                        param: .controlRoom(.mute),
                        ledColor: .red,
                        height: 30
                    )
                    HUIStateButton(
                        title: "DIM",
                        param: .controlRoom(.dim),
                        ledColor: .red,
                        height: 30
                    )
                }
            }
            .frame(minWidth: 110)
                
            VStack {
                PlaceholderKnob(size: 30)
                Spacer().frame(height: 5)
                PlaceholderKnob(size: 30)
                Spacer().frame(height: 5)
                PlaceholderKnob(size: 30)
            }
            .spaceHogFrame()
                
            VStack {
                HUIStateButton(
                    title: "OUTPUT 1",
                    param: .controlRoom(.output1),
                    ledColor: .green,
                    height: 30,
                    fontSize: 9
                )
                HUIStateButton(
                    title: "OUTPUT 2",
                    param: .controlRoom(.output2),
                    ledColor: .green,
                    height: 30,
                    fontSize: 9
                )
                HUIStateButton(
                    title: "OUTPUT 3\n/ PHONES",
                    param: .controlRoom(.output3),
                    ledColor: .green,
                    height: 30,
                    fontSize: 9
                )
            }
            .spaceHogFrame()
        }
    }
}
