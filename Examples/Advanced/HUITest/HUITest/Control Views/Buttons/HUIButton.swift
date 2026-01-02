//
//  HUIButton.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

struct HUIButton: View, MomentaryButtonProtocol {
    @Environment(HUISurface.self) var huiSurface
    
    let title: LocalizedStringKey?
    let image: Image?
    let huiSwitch: HUISwitch
    var width: CGFloat?
    var height: CGFloat?
    var fontSize: CGFloat?
    
    init(
        title: LocalizedStringKey? = nil,
        image: Image? = nil,
        param: HUISwitch,
        width: CGFloat? = nil, // MomentaryButton.kDefaultWidth,
        height: CGFloat? = nil, // MomentaryButton.kDefaultHeight,
        fontSize: CGFloat? = nil
    ) {
        self.title = title
        self.image = image
        huiSwitch = param
        self.width = width
        self.height = height
        self.fontSize = fontSize
    }
    
    var body: some View {
        MomentaryButton(
            title: title,
            image: image,
            fontSize: fontSize,
            width: width,
            height: height
        ) {
            huiSurface.transmitSwitch(huiSwitch, state: true)
        } releasedAction: {
            huiSurface.transmitSwitch(huiSwitch, state: false)
        }
        .foregroundColor(.black)
    }
}
