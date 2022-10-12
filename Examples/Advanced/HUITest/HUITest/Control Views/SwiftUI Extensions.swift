//
//  SwiftUI Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension View {
    func spaceHogFrame() -> some View {
        ZStack {
            Color.clear
            self
        }
    }
}
