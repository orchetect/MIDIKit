//
//  EditSection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension HUISurfaceView.RightSideView.SwitchMatrixView {
    struct EditSection: View {
        var body: some View {
            VStack {
                HUISectionLabel("EDIT")
                
                HStack {
                    VStack {
                        HUIStateButton(
                            title: "CAPTURE",
                            param: .edit(.capture),
                            ledColor: .yellow,
                            fontSize: 9
                        )
                        HUIStateButton(
                            title: "CUT",
                            param: .edit(.cut),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "PASTE",
                            param: .edit(.paste),
                            ledColor: .yellow
                        )
                    }
                    
                    VStack {
                        HUIStateButton(
                            title: "SEPARATE",
                            param: .edit(.separate),
                            ledColor: .yellow,
                            fontSize: 8.5
                        )
                        HUIStateButton(
                            title: "COPY",
                            param: .edit(.copy),
                            ledColor: .yellow
                        )
                        HUIStateButton(
                            title: "DELETE",
                            param: .edit(.delete),
                            ledColor: .yellow
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
