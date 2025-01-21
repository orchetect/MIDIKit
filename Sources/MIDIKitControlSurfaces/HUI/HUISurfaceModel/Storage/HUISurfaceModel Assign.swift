//
//  HUISurfaceModel Assign.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModel {
    /// State storage representing the Assign controls.
    public struct Assign: Equatable, Hashable {
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
        public var `default` = false
    }
}

extension HUISurfaceModel.Assign: HUISurfaceModelState {
    public typealias Switch = HUISwitch.Assign
    
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .sendA:           return sendA
        case .sendB:           return sendB
        case .sendC:           return sendC
        case .sendD:           return sendD
        case .sendE:           return sendE
        case .pan:             return pan
        
        case .recordReadyAll:  return recordReadyAll
        case .bypass:          return bypass
        case .mute:            return mute
        case .shift:           return shift
        case .suspend:         return suspend
        case .default:         return `default`
        case .assign:          return assign
        case .input:           return input
        case .output:          return output
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .sendA:           sendA = state
        case .sendB:           sendB = state
        case .sendC:           sendC = state
        case .sendD:           sendD = state
        case .sendE:           sendE = state
        case .pan:             pan = state
            
        case .recordReadyAll:  recordReadyAll = state
        case .bypass:          bypass = state
        case .mute:            mute = state
        case .shift:           shift = state
        case .suspend:         suspend = state
        case .default:         `default` = state
        case .assign:          assign = state
        case .input:           input = state
        case .output:          output = state
        }
    }
}
