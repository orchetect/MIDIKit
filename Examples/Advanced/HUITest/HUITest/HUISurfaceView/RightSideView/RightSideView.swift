//
//  RightSideView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension HUISurfaceView {
    static let kRightSideViewWidth: CGFloat = 500
}

struct RightSideView: View {
    var body: some View {
        VStack {
            ParameterEditAssignView()
            HUISectionDivider(.horizontal)
            FKeysView()
            HUISectionDivider(.horizontal)
            SwitchMatrixView()
            HUISectionDivider(.horizontal)
            Spacer().frame(height: 10)
            HStack(alignment: .top, spacing: nil) {
                VStack {
                    Spacer().frame(height: 20)
                    MainTimeDisplayView()
                    HUISectionDivider(.horizontal)
                    ControlRoomView()
                    HUISectionDivider(.horizontal)
                }
                Spacer().frame(width: 25)
                NumPadView()
            }
            TransportView()
            
            Spacer()
        }
        .frame(width: HUISurfaceView.kRightSideViewWidth, alignment: .top)
    }
}
