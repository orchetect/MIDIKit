//
//  MIDIKit-0.9.4.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension Collection where Element: MIDIEndpoint {
    @available(
        *,
        deprecated,
        renamed: "filter(_:_:in:)",
        message: "This method has been refactored."
    )
    public func filter(
        using endpointFilter: MIDIEndpointFilter,
        in manager: MIDIManager,
        isIncluded: Bool = true
    ) -> [Element] {
        switch isIncluded {
        case true:
            return filter(endpointFilter, in: manager)
        case false:
            return filter(dropping: endpointFilter, in: manager)
        }
    }
}

#endif
