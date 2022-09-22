//
//  HUISwitch Wrapper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftUI
import MIDIKitControlSurfaces

extension HUISwitch {
    /// Because SwiftUI wants to crash constantly for no reason.
    /// The workaround is to make a class wrapper for `HUISwitch` instance storage in a SwiftUI View. That prevents SwiftUI from attempting to compare the stored enum instance when recalculating the view during runtime and resulting in inexplicable crashes.
    ///
    /// References:
    /// - [SwiftUI Crash in AG::LayoutDescriptor::compare](https://noahgilmore.com/blog/swiftui-equatable-crash/)
    /// - [Twitter Thread](https://twitter.com/orchetect/status/1416871188723224577)
    class Wrapper {
        let wrapped: HUISwitch

        init(_ wrapped: HUISwitch) {
            self.wrapped = wrapped
        }
    }
}
