//
//  MomentaryButtonProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import SwiftUI

protocol MomentaryButtonProtocol where Self: View {
    var title: LocalizedStringKey? { get }
    var fontSize: CGFloat? { get set }
    var width: CGFloat? { get set }
}

// MARK: - View Modifiers

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
