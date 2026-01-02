//
//  HUIStateButton.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

struct HUIStateButton: View, MomentaryButtonProtocol  {
    @Environment(HUISurface.self) var huiSurface
    
    let title: LocalizedStringKey?
    let image: Image?
    let huiSwitch: HUISwitch
    let ledColor: Color
    var width: CGFloat?
    var height: CGFloat?
    var fontSize: CGFloat?
    
    init(
        title: LocalizedStringKey? = nil,
        image: Image? = nil,
        param: HUISwitch,
        ledColor: HUISwitchColor,
        width: CGFloat? = nil, // MomentaryButton.kDefaultWidth,
        height: CGFloat? = nil, // MomentaryButton.kDefaultHeight,
        fontSize: CGFloat? = nil
    ) {
        self.title = title
        self.image = image
        huiSwitch = param
        self.ledColor = ledColor.color
        self.width = width
        self.height = height
        self.fontSize = fontSize
    }
    
    var body: some View {
        HUIButton(
            title: title,
            image: image,
            param: huiSwitch,
            width: width,
            height: height,
            fontSize: fontSize
        )
        .colorMultiply(
            huiSurface.model.state(of: huiSwitch)
                ? ledColor
                : Color(white: 1, opacity: 1)
        )
    }
}

// MARK: - Types

extension HUIStateButton {
    enum HUISwitchColor: Equatable, Hashable, Sendable {
        case yellow
        case green
        case red
        
        var color: Color {
            switch self {
            case .yellow: .yellow
            case .green: .green
            case .red: .red
            }
        }
    }
}
