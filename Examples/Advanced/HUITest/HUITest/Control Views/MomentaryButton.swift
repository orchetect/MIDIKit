//
//  MomentaryButton.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitControlSurfaces

extension MomentaryButton {
    fileprivate static let kDefaultWidth: CGFloat = 50
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
    
    let title: String
    var fontSize: CGFloat?
    var width: CGFloat?
    var height: CGFloat?
    let pressedAction: () -> Void
    let releasedAction: () -> Void
    
    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: fontSize ?? Self.kDefaultFontSize))
                .multilineTextAlignment(.center)
                .padding(2)
                .frame(width: width, height: height)
                .background(isPressed ? Color.blue : Color.gray)
        }
        .highPriorityGesture(
            // this is a workaround to enable a button which triggers two different actions, one on mouse-down and one on mouse-up
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        pressedAction()
                    }
                    isPressed = true
                }
                .onEnded { _ in
                    releasedAction()
                    isPressed = false
                }
        )
    }
}

struct HUIButton: View, MomentaryButtonProtocol {
    @EnvironmentObject var huiSurface: HUISurface

    let title: String
    var fontSize: CGFloat?
    var width: CGFloat?
    private let huiSwitch: HUISwitch.Wrapper
    
    init(
        _ title: String = "",
        _ param: HUISwitch,
        width: CGFloat? = MomentaryButton.kDefaultWidth,
        fontSize: CGFloat? = nil
    ) {
        self.title = title
        huiSwitch = .init(param)
        self.width = width
        self.fontSize = fontSize
    }
    
    var body: some View {
        MomentaryButton(
            title: title,
            fontSize: fontSize,
            width: width
        ) {
            huiSurface.transmitSwitch(huiSwitch.wrapped, state: true)
        } releasedAction: {
            huiSurface.transmitSwitch(huiSwitch.wrapped, state: false)
        }
        .foregroundColor(.black)
    }
}

struct HUIStateButton: View, MomentaryButtonProtocol  {
    @EnvironmentObject var huiSurface: HUISurface

    let title: String
    var fontSize: CGFloat?
    var width: CGFloat?
    private let huiSwitch: HUISwitch.Wrapper
    let ledColor: Color

    init(
        _ title: String = "",
        _ param: HUISwitch,
        _ ledColor: HUISwitchColor,
        width: CGFloat? = MomentaryButton.kDefaultWidth,
        fontSize: CGFloat? = nil
    ) {
        self.title = title
        self.fontSize = fontSize
        self.width = width
        huiSwitch = .init(param)
        self.ledColor = ledColor.color
    }

    var body: some View {
        HUIButton(
            title,
            huiSwitch.wrapped,
            width: width,
            fontSize: fontSize
        )
        .colorMultiply(
            huiSurface.model.state(of: huiSwitch.wrapped)
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
    @EnvironmentObject var huiSurface: HUISurface
    
    static let kDefaultSize: CGFloat = 40
    
    let title: String
    var fontSize: CGFloat?
    var width: CGFloat?
    var spacing: CGFloat?
    let widthScale: CGFloat
    let heightScale: CGFloat
    private let huiSwitch: HUISwitch.Wrapper
    
    init(
        _ title: String = "",
        _ param: HUISwitch,
        width: CGFloat? = kDefaultSize,
        spacing: CGFloat? = nil,
        widthScale: CGFloat = 1.0,
        heightScale: CGFloat = 1.0,
        fontSize: CGFloat? = 14
    ) {
        self.title = title
        huiSwitch = .init(param)
        self.width = width
        self.spacing = spacing
        self.widthScale = widthScale
        self.heightScale = heightScale
        self.fontSize = fontSize
    }
    
    var body: some View {
        MomentaryButton(
            title: title,
            fontSize: fontSize,
            width: calculateWidth(),
            height: calculateHeight()
        ) {
            huiSurface.transmitSwitch(huiSwitch.wrapped, state: true)
        } releasedAction: {
            huiSurface.transmitSwitch(huiSwitch.wrapped, state: false)
        }
        .foregroundColor(.black)
    }
    
    func calculateWidth() -> CGFloat? {
        guard let width = width else { return nil }
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
        guard let spacing = spacing else { return baseScale }
        
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
