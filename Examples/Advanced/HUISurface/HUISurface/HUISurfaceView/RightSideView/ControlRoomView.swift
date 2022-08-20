//
//  ControlRoomView.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    func ControlRoomView() -> some View {
        HStack {
            VStack {
                HUIStateButton(
                    "INPUT 1",
                    .controlRoom(.input1),
                    .green
                )
                HUIStateButton(
                    "INPUT 2",
                    .controlRoom(.input2),
                    .green
                )
                HUIStateButton(
                    "INPUT 3",
                    .controlRoom(.input3),
                    .green
                )
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                HStack {
                    HUIStateButton(
                        "1:1 DISCRETE",
                        .controlRoom(.discreteInput1to1),
                        .red,
                        fontSize: 9
                    )
                    HUIStateButton(
                        "MONO",
                        .controlRoom(.mono),
                        .red
                    )
                }
                
                RotaryKnob(size: 50)
                Text("MASTER\nVOLUME").font(.system(size: 10))
                
                HStack {
                    HUIStateButton(
                        "MUTE",
                        .controlRoom(.mute),
                        .red
                    )
                    HUIStateButton(
                        "DIM",
                        .controlRoom(.dim),
                        .red
                    )
                }
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                RotaryKnob(size: 30)
                Spacer().frame(height: 5)
                RotaryKnob(size: 30)
                Spacer().frame(height: 5)
                RotaryKnob(size: 30)
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                HUIStateButton(
                    "OUTPUT 1",
                    .controlRoom(.output1),
                    .green,
                    fontSize: 9
                )
                HUIStateButton(
                    "OUTPUT 2",
                    .controlRoom(.output2),
                    .green,
                    fontSize: 9
                )
                HUIStateButton(
                    "OUTPUT 3/PHONES",
                    .controlRoom(.output3),
                    .green,
                    fontSize: 9
                )
            }
            .frame(maxWidth: .infinity)
        }
    }
}
