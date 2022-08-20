//
//  HUI Parameter Wrapper.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftUI
import MIDIKitControlSurfaces

extension MIDI.HUI.Parameter {
    /// Because SwiftUI wants to crash constantly for no reason.
    /// The workaround is to make a class wrapper for MIDI.HUI.Parameter instance storage in a SwiftUI View. That prevents SwiftUI from attempting to compare the stored enum instance when recalculating the view during runtime and resulting in inexplicable crashes.
    ///
    /// References:
    /// - [SwiftUI Crash in AG::LayoutDescriptor::compare](https://noahgilmore.com/blog/swiftui-equatable-crash/)
    /// - [Twitter Thread](https://twitter.com/orchetect/status/1416871188723224577)
    class Wrapper {
        let wrapped: MIDI.HUI.Parameter

        init(_ wrapped: MIDI.HUI.Parameter) {
            self.wrapped = wrapped
        }
    }
}
