//
//  MIDIKitIO-0.8.5.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

// Symbols that were renamed or removed.

extension MIDIInput {
    @available(*, deprecated, renamed: "name")
    public var endpointName: String {
        name
    }
}

extension MIDIOutput {
    @available(*, deprecated, renamed: "name")
    public var endpointName: String {
        name
    }
}

#endif
