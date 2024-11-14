//
//  Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

extension Array where Element: FixedWidthInteger {
    static func randomValues(count: Int) -> [Element] {
        (0 ..< count)
            .map { _ in Element.random(in: Element.min ... Element.max) }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
