//
//  Buttons.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

extension MomentaryButton {
    fileprivate static let kDefaultWidth: CGFloat = 50
    fileprivate static let kDefaultHeight: CGFloat = 25
    fileprivate static let kDefaultFontSize: CGFloat = 10
}

protocol MomentaryButtonProtocol {
    var title: String { get }
    var fontSize: CGFloat? { get set }
    var width: CGFloat? { get set }
}

extension MomentaryButtonProtocol {
    func fontSize(_ fontSize: CGFloat?) -> Self {
        var copy = self
        copy.fontSize = fontSize
        return copy
    }
    
    func width(_ width: CGFloat?) -> Self {
        var copy = self
        copy.width = width
        return copy
    }
}

struct MomentaryButton: View, MomentaryButtonProtocol {
    @State private var isPressed = false
    
    let image: Image?
    let title: String
    var fontSize: CGFloat?
    var width: CGFloat?
    var height: CGFloat?
    let pressedAction: () -> Void
    let releasedAction: () -> Void
    
    init(
        image: Image? = nil,
        title: String,
        fontSize: CGFloat? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        pressedAction: @escaping () -> Void,
        releasedAction: @escaping () -> Void
    ) {
        self.image = image
        self.title = title
        self.fontSize = fontSize
        self.width = width
        self.height = height
        self.pressedAction = pressedAction
        self.releasedAction = releasedAction
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isPressed ? .blue : .gray)
            VStack {
                if let image {
                    if !title.isEmpty { Spacer().frame(height: 4) }
                    image
                }
                if !title.isEmpty {
                    Text(title)
                        .font(.system(size: fontSize ?? Self.kDefaultFontSize))
                        .multilineTextAlignment(.center)
                        .padding(2)
                        .frame(width: width)
                }
            }
        }
        .cornerRadius(3)
        .frame(width: width, height: height)
        .help(title)
        .momentaryPressGesture { state in
            isPressed = state
            if state { pressedAction() } else { releasedAction() }
        }
    }
}

struct HUIButton: View, MomentaryButtonProtocol {
    @Environment(HUISurface.self) var huiSurface

    let image: Image?
    let title: String
    var fontSize: CGFloat?
    var width: CGFloat?
    var height: CGFloat?
    private let huiSwitch: HUISwitch
    
    init(
        image: Image? = nil,
        title: String = "",
        param: HUISwitch,
        width: CGFloat? = nil, // MomentaryButton.kDefaultWidth,
        height: CGFloat? = nil, // MomentaryButton.kDefaultHeight,
        fontSize: CGFloat? = nil
    ) {
        self.image = image
        self.title = title
        huiSwitch = param
        self.width = width
        self.height = height
        self.fontSize = fontSize
    }
    
    var body: some View {
        MomentaryButton(
            image: image,
            title: title,
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

struct HUIStateButton: View, MomentaryButtonProtocol  {
    @Environment(HUISurface.self) var huiSurface

    let image: Image?
    let title: String
    var fontSize: CGFloat?
    var width: CGFloat?
    var height: CGFloat?
    private let huiSwitch: HUISwitch
    let ledColor: Color

    init(
        image: Image? = nil,
        title: String = "",
        param: HUISwitch,
        ledColor: HUISwitchColor,
        width: CGFloat? = nil, // MomentaryButton.kDefaultWidth,
        height: CGFloat? = nil, // MomentaryButton.kDefaultHeight,
        fontSize: CGFloat? = nil
    ) {
        self.image = image
        self.title = title
        self.fontSize = fontSize
        self.width = width
        self.height = height
        huiSwitch = param
        self.ledColor = ledColor.color
    }

    var body: some View {
        HUIButton(
            image: image,
            title: title,
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

extension HUIStateButton {
    enum HUISwitchColor: Equatable, Hashable {
        case yellow
        case green
        case red

        var color: Color {
            switch self {
            case .yellow: return Color.yellow
            case .green: return Color.green
            case .red: return Color.red
            }
        }
    }
}

struct HUINumPadButton: View, MomentaryButtonProtocol {
    @Environment(HUISurface.self) var huiSurface
    
    static let kDefaultSize: CGFloat = 40
    
    let image: Image?
    let title: String
    var fontSize: CGFloat?
    var width: CGFloat?
    var spacing: CGFloat?
    let widthScale: CGFloat
    let heightScale: CGFloat
    private let huiSwitch: HUISwitch
    
    init(
        image: Image? = nil,
        title: String = "",
        param: HUISwitch,
        width: CGFloat? = kDefaultSize,
        spacing: CGFloat? = nil,
        widthScale: CGFloat = 1.0,
        heightScale: CGFloat = 1.0,
        fontSize: CGFloat? = 14
    ) {
        self.image = image
        self.title = title
        huiSwitch = param
        self.width = width
        self.spacing = spacing
        self.widthScale = widthScale
        self.heightScale = heightScale
        self.fontSize = fontSize
    }
    
    var body: some View {
        MomentaryButton(
            image: image,
            title: title,
            fontSize: fontSize,
            width: calculateWidth(),
            height: calculateHeight()
        ) {
            huiSurface.transmitSwitch(huiSwitch, state: true)
        } releasedAction: {
            huiSurface.transmitSwitch(huiSwitch, state: false)
        }
        .foregroundColor(.black)
        .cornerRadius(5)
    }
    
    func calculateWidth() -> CGFloat? {
        guard let width else { return nil }
        return width * scaleFactor(size: width, baseScale: widthScale)
    }
    
    func calculateHeight() -> CGFloat? {
        // mirror width (square)
        guard let height = width else { return nil }
        return height * scaleFactor(size: height, baseScale: heightScale)
    }
    
    func scaleFactor(
        size: CGFloat,
        baseScale: CGFloat
    ) -> CGFloat {
        if baseScale <= 1.0 { return baseScale }
        guard let spacing else { return baseScale }
        
        let numberOfSpacers = floor(baseScale) - 1
        let spacerFactor = numberOfSpacers * (spacing / size)
        return baseScale + spacerFactor
    }
}

#if DEBUG
struct MomentaryButton_Previews: PreviewProvider {
    static var previews: some View {
        MomentaryButton(
            title: "BUTTON",
            width: nil,
            pressedAction: { },
            releasedAction: { }
        )
    }
}
#endif
