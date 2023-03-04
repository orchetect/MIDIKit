//
//  Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Wrapper to convert between `Int` and another integer type
/// since `@AppStorage` only supports `Int`.
func intAdapter<T: BinaryInteger>(_ storage: Binding<Int?>) -> Binding<T?> {
    Binding {
        guard let storage = storage.wrappedValue else { return nil }
        return T(exactly: storage)
    } set: { new in
        guard let new else {
            storage.wrappedValue = nil
            return
        }
        storage.wrappedValue = Int(new)
    }
}
