//
//  MomentaryButton.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

struct MomentaryButton: View, MomentaryButtonProtocol {
    @State private var isPressed = false
    
    let title: LocalizedStringKey?
    let image: Image?
    var fontSize: CGFloat?
    var width: CGFloat?
    var height: CGFloat?
    let pressedAction: () -> Void
    let releasedAction: () -> Void
    
    init(
        title: LocalizedStringKey? = nil,
        image: Image? = nil,
        fontSize: CGFloat? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        pressedAction: @escaping () -> Void,
        releasedAction: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
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
                    if title != nil { Spacer().frame(height: 4) }
                    image
                }
                if let title {
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
        .help(title ?? "")
        .momentaryPressGesture { state in
            isPressed = state
            if state { pressedAction() } else { releasedAction() }
        }
    }
}

// MARK: - Static

extension MomentaryButton {
    fileprivate static let kDefaultWidth: CGFloat = 50
    fileprivate static let kDefaultHeight: CGFloat = 25
    fileprivate static let kDefaultFontSize: CGFloat = 10
}

// MARK: - Previews

#if DEBUG
#Preview {
    MomentaryButton(
        title: "BUTTON",
        width: nil,
        pressedAction: { },
        releasedAction: { }
    )
    .frame(width: 80, height: 60)
    .padding()
}
#endif
