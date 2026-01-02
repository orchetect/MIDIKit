//
//  HUINumPadButton.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

struct HUINumPadButton: View, MomentaryButtonProtocol {
    @Environment(HUISurface.self) var huiSurface
    
    let title: LocalizedStringKey?
    let image: Image?
    let huiSwitch: HUISwitch
    var width: CGFloat?
    var spacing: CGFloat?
    let widthScale: CGFloat
    let heightScale: CGFloat
    var fontSize: CGFloat?
    
    init(
        title: LocalizedStringKey? = nil,
        image: Image? = nil,
        param: HUISwitch,
        width: CGFloat? = kDefaultSize,
        spacing: CGFloat? = nil,
        widthScale: CGFloat = 1.0,
        heightScale: CGFloat = 1.0,
        fontSize: CGFloat? = 14
    ) {
        self.title = title
        self.image = image
        huiSwitch = param
        self.width = width
        self.spacing = spacing
        self.widthScale = widthScale
        self.heightScale = heightScale
        self.fontSize = fontSize
    }
    
    var body: some View {
        MomentaryButton(
            title: title,
            image: image,
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
}

// MARK: - Static

extension HUINumPadButton {
    static let kDefaultSize: CGFloat = 40
}

// MARK: - ViewModel

extension HUINumPadButton {
    private func calculateWidth() -> CGFloat? {
        guard let width else { return nil }
        return width * scaleFactor(size: width, baseScale: widthScale)
    }
    
    private func calculateHeight() -> CGFloat? {
        // mirror width (square)
        guard let height = width else { return nil }
        return height * scaleFactor(size: height, baseScale: heightScale)
    }
    
    private func scaleFactor(
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
