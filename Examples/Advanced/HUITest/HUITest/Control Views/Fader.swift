//
//  Fader.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

// TODO: this struct could be moved to AudioKit/Controls repo

import SwiftUI
@testable import Controls // TODO: remove testable

/// Fader
public struct Fader: View {
    @Binding var isTouched: Bool
    @Binding var location: Float
    
    var backgroundColor: Color = .gray
    var foregroundColor: Color = .red
    var cornerRadius: CGFloat = 5
    var indicatorPadding: CGFloat = 0.1
    var indicatorHeight: CGFloat = 60
    
    /// Initialize a fader with value and touch state bindings.
    /// - Parameters:
    ///   - value: Fader value.
    ///   - isTouched: Fader cap is being touched by the mouse (or held if a touch screen).
    public init(
        value: Binding<Float>,
        isTouched: Binding<Bool>
    ) {
        _location = value
        _isTouched = isTouched
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(backgroundColor)
            
            Control(
                value: $location,
                geometry: .verticalDrag(),
                padding: CGSize(width: 0, height: indicatorHeight / 2),
                onStarted: { isTouched = true },
                onEnded: { isTouched = false }
            ) { geo in
                Canvas { cx, size in
                    let viewport = CGRect(origin: .zero, size: size)
                    let indicatorRect = CGRect(
                        origin: .zero,
                        size: CGSize(
                            width: geo.size.width - geo.size.width * indicatorPadding * 2,
                            height: indicatorHeight - geo.size.width * indicatorPadding * 2
                        )
                    )
                    
                    let activeHeight = viewport.size.height - indicatorRect.size.height
                    
                    let offsetRect = indicatorRect.offset(by: CGSize(
                        width: 0,
                        height: activeHeight * (1 - CGFloat(location))
                    ))
                    let cr = min(indicatorRect.height / 2, cornerRadius)
                    let ind = Path(roundedRect: offsetRect, cornerRadius: cr)
                    
                    cx.fill(ind, with: .color(foregroundColor))
                }
                .animation(.spring(response: 0.2), value: location)
                .padding(geo.size.width * indicatorPadding)
            }
        }
    }
}

extension Fader {
    /// Modifier to change the background color of the fader.
    /// - Parameter backgroundColor: background color
    public func backgroundColor(_ color: Color) -> Self {
        var copy = self
        copy.backgroundColor = color
        return copy
    }
    
    /// Modifier to change the foreground color of the fader.
    /// - Parameter foregroundColor: foreground color
    public func foregroundColor(_ color: Color) -> Self {
        var copy = self
        copy.foregroundColor = color
        return copy
    }
    
    /// Modifier to change the corner radius of the fader and the indicator.
    /// - Parameter cornerRadius: radius (make very high for a circular indicator)
    public func cornerRadius(_ radius: CGFloat) -> Self {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }
    
    /// Modifier to change the size of the indicator.
    /// - Parameter indicatorHeight: preferred height
    public func indicatorHeight(_ height: CGFloat) -> Self {
        var copy = self
        copy.indicatorHeight = height
        return copy
    }
}
