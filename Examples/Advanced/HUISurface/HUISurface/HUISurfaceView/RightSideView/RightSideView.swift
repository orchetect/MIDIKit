//
//  RightSideView.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension HUISurfaceView {
    static let kRightSideViewWidth: CGFloat = 500
}

extension HUISurfaceView {
    func RightSideView() -> some View {
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
        .frame(width: Self.kRightSideViewWidth, alignment: .top)
    }
}
