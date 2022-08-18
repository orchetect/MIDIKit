/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Protocols/Protocols.swift
///
/// Borrowed from OTCore 1.4.2 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

// MARK: - NumberEndianness

/// Enum describing endianness when stored in data form.
public enum NumberEndianness {
    case platformDefault
    case littleEndian
    case bigEndian
}

#if canImport(CoreFoundation)
import CoreFoundation

extension NumberEndianness {
    /// Returns the current system hardware's byte order endianness.
    public static let system: NumberEndianness =
        CFByteOrderGetCurrent() == CFByteOrderBigEndian.rawValue
            ? .bigEndian
            : .littleEndian
}
#endif
