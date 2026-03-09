//
//  MIDIFile DecodeOptions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    /// MIDI file decoding options.
    public struct DecodeOptions: OptionSet {
        public let rawValue: Int
        
        /// Detects RPN/NRPN message sequences and bundles them up into rpn/nrpn events.
        /// If omitted, the CC messages that make up RPN/NRPN message sequences will be parsed as plain CC messages.
        public static let bundleParameterNumbers = DecodeOptions(rawValue: 1)
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

extension MIDIFile.DecodeOptions: Equatable { }

extension MIDIFile.DecodeOptions: Hashable { }

extension MIDIFile.DecodeOptions: Sendable { }

// MARK: - Static Constructors

extension MIDIFile.DecodeOptions {
    /// Default MIDI file decode options.
    public static func `default`() -> Self {
        [.bundleParameterNumbers]
    }
}
