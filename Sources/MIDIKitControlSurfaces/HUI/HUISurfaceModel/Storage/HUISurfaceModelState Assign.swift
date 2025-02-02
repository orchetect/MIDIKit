//
//  HUISurfaceModelState Assign.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Assign controls.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class Assign {
        /// 4-character text display.
        public var textDisplay: HUISmallDisplayString = .init()
        
        public var recordReadyAll = false
        public var bypass = false
        
        public var sendA = false
        public var sendB = false
        public var sendC = false
        public var sendD = false
        public var sendE = false
        public var pan = false
        
        public var mute = false
        public var shift = false
        
        public var input = false
        public var output = false
        public var assign = false
        
        public var suspend = false
        public var defaultBtn = false
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.Assign: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.Assign
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .sendA:          sendA
        case .sendB:          sendB
        case .sendC:          sendC
        case .sendD:          sendD
        case .sendE:          sendE
        case .pan:            pan
        case .recordReadyAll: recordReadyAll
        case .bypass:         bypass
        case .mute:           mute
        case .shift:          shift
        case .suspend:        suspend
        case .defaultBtn:     defaultBtn
        case .assign:         assign
        case .input:          input
        case .output:         output
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .sendA:          sendA = state
        case .sendB:          sendB = state
        case .sendC:          sendC = state
        case .sendD:          sendD = state
        case .sendE:          sendE = state
        case .pan:            pan = state
        case .recordReadyAll: recordReadyAll = state
        case .bypass:         bypass = state
        case .mute:           mute = state
        case .shift:          shift = state
        case .suspend:        suspend = state
        case .defaultBtn:     defaultBtn = state
        case .assign:         assign = state
        case .input:          input = state
        case .output:         output = state
        }
    }
}
