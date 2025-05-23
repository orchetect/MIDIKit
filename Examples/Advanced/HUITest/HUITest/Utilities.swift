//
//  Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftUI

/// Formatter that limits character length.
class MaxLengthFormatter: Formatter {
    public var maxCharLength: Int
    
    // MARK: Init
    
    public init(maxCharLength: Int) {
        self.maxCharLength = maxCharLength
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        maxCharLength = 10000
        super.init(coder: coder)
    }
    
    // MARK: Overrides
    
    override func string(for obj: Any?) -> String? {
        guard let obj = obj as? String else { return nil }
        
        return String(obj.prefix(maxCharLength))
    }
    
    override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        obj?.pointee = string as NSString
        return true
    }
    
    override func isPartialStringValid(
        _ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>,
        proposedSelectedRange proposedSelRangePtr: NSRangePointer?,
        originalString origString: String,
        originalSelectedRange origSelRange: NSRange,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        let partialString = partialStringPtr.pointee as String
        return partialString.count <= maxCharLength
    }
    
    override func isPartialStringValid(
        _ partialString: String,
        newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        partialString.count <= maxCharLength
    }
}

extension Scene {
    /// Scene modifier to run arbitrary code when the scene's body is evaluated.
    func onSceneBody(_ block: @escaping () -> Void) -> some Scene {
        Task { @MainActor in block() }
        return self
    }
}

extension CGRect {
    func offset(by off: CGSize) -> CGRect {
        offsetBy(dx: off.width, dy: off.height)
    }
}

extension Comparable {
    /// Returns the value clamped to the passed range.
    @_disfavoredOverload @inlinable
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
