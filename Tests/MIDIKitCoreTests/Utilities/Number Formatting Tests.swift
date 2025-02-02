//
//  Number Formatting Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct NumberFormatting_Tests {
    @Test
    func roundedDecimalPlaces_Default() {
        #expect((1.126).rounded(decimalPlaces: 4) == 1.126)
        #expect((1.126).rounded(decimalPlaces: 3) == 1.126)
        #expect((1.126).rounded(decimalPlaces: 2) == 1.13)
        #expect((1.126).rounded(decimalPlaces: 1) == 1.1)
        #expect((1.126).rounded(decimalPlaces: 0) == 1.0)
        #expect((1.126).rounded(decimalPlaces: -1) == 1.0)
    }
}
