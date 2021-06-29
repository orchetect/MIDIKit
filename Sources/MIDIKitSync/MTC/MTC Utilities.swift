//
//  MTC Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import TimecodeKit

extension MTC {
	
	/// Internal: Returns `true` if both tuples are considered equal.
	internal static func mtcIsEqual(
		_ lhs: (mtcComponents: Timecode.Components,
				mtcFrameRate: MTCFrameRate)?,
		_ rhs: (mtcComponents: Timecode.Components,
				mtcFrameRate: MTCFrameRate)?
	) -> Bool {
		
		guard let lhs = lhs,
			  let rhs = rhs
		else { return false }
		
		let lhsComponents = lhs.mtcComponents
		let rhsComponents = rhs.mtcComponents
		
		let componentsAreEqual =
			lhsComponents.h == rhsComponents.h &&
			lhsComponents.m == rhsComponents.m &&
			lhsComponents.s == rhsComponents.s &&
			lhsComponents.f == rhsComponents.f
		
		let mtcFrameRatesAreEqual =
			lhs.mtcFrameRate == rhs.mtcFrameRate
		
		return componentsAreEqual && mtcFrameRatesAreEqual
		
	}
	
}
