//
//  HUISurface.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

#if compiler(>=6.0)
internal import MIDIKitInternals
#else
@_implementationOnly import MIDIKitInternals
#endif

/// Object representing a single HUI control surface device, holding a model of its state and
/// providing granular update notifications.
///
/// This object would typically be used by a client application (ie: a control surface application
/// on an iPad) in order to manage state of a HUI surface. It interfaces with HUI host
/// software/hardware through bidirectional MIDI (input and output).
///
/// > HUI (_Human User Interface for Digital Audio Workstations_) is a DAW control surface protocol
/// > developed by Mackie that uses MIDI events as its underlying encoding.
/// >
/// > References:
/// > - [HUI Hardware Reference Guide](https://loudaudio.netx.net/portals/loud-public/#asset/9795)
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@Observable public final class HUISurface {
    // MARK: - State Model
    
    /// HUI control surface state model.
    /// Represents state of an entire HUI control surface (all controls, display elements, etc.).
    ///
    /// This property is observable with Combine/SwiftUI and can trigger UI updates upon changes
    /// when ``HUISurface`` is instanced as a `@StateObject var`.
    public internal(set) var model: HUISurfaceModel
    
    // MARK: - Decoder
    
    @ObservationIgnored
    var decoder: HUIHostEventDecoder!
    
    // MARK: - Handlers
    
    /// HUI event receive handler.
    public typealias ModelNotificationHandler = (
        (_ notification: HUISurfaceModelNotification) -> Void
    )
    
    /// Notification handler that is called as a result of the ``model`` being updated from received
    /// HUI events.
    public var modelNotificationHandler: ModelNotificationHandler?
    
    /// Notification handler will always be called even when a received HUI MIDI event from host
    /// does not result in a change to the HUI surface state model.
    public var alwaysNotify: Bool = false
    
    /// Remote presence state change handler (when pings resume or cease after timeout).
    public typealias PresenceChangedHandler = (_ isPresent: Bool) -> Void
    
    /// Called when the remote presence state changes (when pings resume or cease after timeout).
    public var remotePresenceChangedHandler: PresenceChangedHandler?
    
    @ObservationIgnored
    public var midiOutHandler: MIDIOutHandler?
    
    // MARK: - Presence
    
    /// Time duration to wait since the last ping received before transitioning ``isRemotePresent``
    /// to `false`.
    ///
    /// HUI pings are sent from the host to surface(s) every 1 second. A timeout duration between 2
    /// ... 5 seconds is reasonable depending on desired leeway.
    public var remotePresenceTimeout: TimeInterval = 2.0 {
        didSet {
            // validate
            if remotePresenceTimeout < 1.1 { remotePresenceTimeout = 1.1 }
            // update timer interval
            Task {
                await remotePresenceTimer?.setRate(.seconds(remotePresenceTimeout))
                await remotePresenceTimer?.restart()
            }
        }
    }
    
    @ObservationIgnored
    var remotePresenceTimer: SafeDispatchTimer?
    
    func setupRemotePresenceTimer() {
        guard remotePresenceTimer == nil else { return }
        
        remotePresenceTimer = .init(
            rate: .seconds(remotePresenceTimeout),
            leeway: .milliseconds(50),
            eventHandler: { [weak self] in
                self?.isRemotePresent = false
                Task { await self?.remotePresenceTimer?.stop() }
            }
        )
    }
    
    /// This property will be `true` while ping messages are being received.
    /// If ping messages are interrupted, this property with transition to `false`.
    /// It will transition back to `true` once received ping messages resume.
    ///
    /// Ping timeout can be set to a custom value by setting the ``remotePresenceTimeout`` property.
    ///
    /// This property is observable with Combine/SwiftUI and can trigger UI updates upon changes.
    public internal(set) var isRemotePresent: Bool = false {
        didSet {
            guard oldValue != isRemotePresent else { return }
            remotePresenceChangedHandler?(isRemotePresent)
        }
    }
    
    func receivedPing() {
        Task { await remotePresenceTimer?.restart(firingNow: false) }
        isRemotePresent = true
        
        // send ping-reply if ping request is received
        transmitPing()
    }
    
    // MARK: - Init
    
    public init(
        alwaysNotify: Bool = false,
        modelNotificationHandler: ModelNotificationHandler? = nil,
        remotePresenceChangedHandler: PresenceChangedHandler? = nil,
        midiOutHandler: MIDIOutHandler? = nil
    ) {
        self.alwaysNotify = alwaysNotify
        self.modelNotificationHandler = modelNotificationHandler
        self.midiOutHandler = midiOutHandler
        
        model = HUISurfaceModel()
        
        decoder = HUIHostEventDecoder { [weak self] hostEvent in
            guard let self else { return }
            
            if case .ping = hostEvent {
                self.receivedPing()
            }
                
            // process event
            let result = self.model.updateState(
                from: hostEvent,
                alwaysNotify: self.alwaysNotify
            )
            switch result {
            case let .changed(notification):
                self.modelNotificationHandler?(notification)
            case .unchanged:
                break
            case let .unhandled(hostEvent):
                Logger.debug("Unhandled HUI event: \(hostEvent)")
            }
        }
        
        // presence timer
        setupRemotePresenceTimer()
        
        // HUI control surfaces send a System Reset message when they are powered on
        transmitSystemReset()
    }
    
    deinit {
        // HUI control surfaces send a System Reset message when they are powered off
        transmitSystemReset()
    }
    
    // MARK: - Methods
    
    /// Resets state back to init state. Handlers are unaffected.
    public func reset() {
        model = HUISurfaceModel()
        decoder.reset()
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurface: ReceivesMIDIEvents {
    public func midiIn(event: MIDIEvent) {
        // capture MIDI Device Inquiry first
        switch event {
        case .deviceInquiryRequest(deviceID: 0x00),
             .deviceInquiryRequest(deviceID: 0x7F):
            let diResponse: MIDIEvent = .deviceInquiryResponse(
                deviceID: 0x00,
                manufacturer: HUIConstants.kMIDI.kSysEx.kManufacturer,
                deviceFamilyCode: 0x05, // TODO: needs correct value
                deviceFamilyMemberCode: 0x00, // TODO: needs correct value
                softwareRevision: (1, 0, 0, 0) // TODO: needs correct value
            )
            midiOut(diResponse)
        default:
            decoder.midiIn(event: event)
        }
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurface: SendsMIDIEvents {
    // protocol requirements are implemented in class body
}
