//
//  MTC Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import TimecodeKit

/// Internal:
/// Returns `true` if both tuples are considered equal.
func mtcIsEqual(
    _ lhs: (
        mtcComponents: Timecode.Components,
        mtcFrameRate: MTCFrameRate
    )?,
    _ rhs: (
        mtcComponents: Timecode.Components,
        mtcFrameRate: MTCFrameRate
    )?
) -> Bool {
    guard let strongLHS = lhs,
          let strongRHS = rhs
    else { return false }
        
    let lhsComponents = strongLHS.mtcComponents
    let rhsComponents = strongRHS.mtcComponents
        
    let componentsAreEqual =
        lhsComponents.h == rhsComponents.h &&
        lhsComponents.m == rhsComponents.m &&
        lhsComponents.s == rhsComponents.s &&
        lhsComponents.f == rhsComponents.f
        
    let mtcFrameRatesAreEqual =
        strongLHS.mtcFrameRate == strongRHS.mtcFrameRate
        
    return componentsAreEqual && mtcFrameRatesAreEqual
}
    
/// Internal:
/// Converts MTC components and quarter frames to full-frame components
func convertToFullFrameComponents(
    mtcComponents: Timecode.Components,
    mtcQuarterFrames: UInt8
) -> Timecode.Components {
    var newComponents = mtcComponents
    newComponents.f += ((25 * Int(mtcQuarterFrames)) / 100)
        
    return newComponents
}
