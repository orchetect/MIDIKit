//
//  SwiftUI Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension View {
    func spaceHogFrame(alignment: Alignment = .center) -> some View {
        ZStack(alignment: alignment) {
            Color.clear
            self
        }
    }
}
