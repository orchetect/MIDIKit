//
//  HUIModel Assign.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIModel {
    /// State storage representing the Assign controls.
    public struct Assign: Equatable, Hashable {
        /// Text display (4 character width).
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

extension HUIModel.Assign: HUISurfaceStateProtocol {
    public typealias Param = HUIParameter.Assign
    
    public func state(of param: Param) -> Bool {
        switch param {
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
    
    public mutating func setState(of param: Param, to state: Bool) {
        switch param {
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
