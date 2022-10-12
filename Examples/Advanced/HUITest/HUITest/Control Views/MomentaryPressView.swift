//
//  MomentaryPressView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension View {
    func momentaryPressGesture(
        action: @escaping (_ state: Bool) -> Void
    ) -> some View {
        MomentaryPressView(action: action, self)
    }
}

struct MomentaryPressView<Content: View>: View {
    private let content: Content
    private let action: (_ state: Bool) -> Void
    
    @State private var isPressed = false
    
    init(
        action: @escaping (_ state: Bool) -> Void,
        _ content: Content
    ) {
        self.action = action
        self.content = content
    }
    
    var body: some View {
        content
            .highPriorityGesture(
                // this is a workaround to enable a button which triggers two different actions, one on mouse-down and one on mouse-up
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            action(true)
                        }
                        isPressed = true
                    }
                    .onEnded { _ in
                        action(false)
                        isPressed = false
                    }
            )
    }
}
