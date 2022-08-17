//
//  MTC Encoder.swift
//  MIDIKitSync • https://github.com/orchetect/MIDIKitSync
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import MIDIKitInternals
import TimecodeKit

/// MTC (MIDI Timecode) stream encoder object.
///
/// Takes timecode values and produces a stream of MIDI events.
///
/// This object is not affected by or reliant on timing at all and simply processes events as they are received. For outbound MTC sync, use the `MTCGenerator` wrapper object which adds additional abstraction for generating MTC sync.
public class MTCEncoder: SendsMIDIEvents {
    // MARK: - Public properties
        
    /// Returns current `Timecode` at `localFrameRate`, scaling if necessary.
    public var timecode: Timecode {
        guard let scaledFrames = mtcFrameRate.scaledFrames(
            fromRawMTCFrames: mtcComponents.f,
            quarterFrames: mtcQuarterFrame,
            to: localFrameRate
        ) else {
            // rates are not compatible; return a default instead of failing
            // in future we may want this to be an error condition
            return Timecode(at: localFrameRate)
        }
            
        var scaledComponents = mtcComponents
        scaledComponents.f = Int(scaledFrames)
        // sanitize: clear subframes since we're working at 1-frame resolution with timecode display values
        scaledComponents.sf = 0
            
        return Timecode(
            wrapping: scaledComponents,
            at: localFrameRate,
            limit: ._24hours
        )
    }
        
    /// Last internal MTC SPMTE timecode components formed from outgoing MTC data.
    @ThreadSafeAccess
    public internal(set) var mtcComponents = Timecode.Components()
        
    internal func setMTCComponents(mtc newComponents: Timecode.Components) {
        mtcComponents = newComponents
    }
        
    /// Local frame rate (desired rate, not internal MTC SMPTE frame rate).
    public internal(set) var localFrameRate: Timecode.FrameRate = ._30
        
    /// Set local frame rate (desired rate, not internal MTC SMPTE frame rate).
    internal func setLocalFrameRate(_ newFrameRate: Timecode.FrameRate) {
        localFrameRate = newFrameRate
        mtcFrameRate = newFrameRate.mtcFrameRate
    }
        
    /// The base MTC frame rate last transmitted.
    public internal(set) var mtcFrameRate: MTCFrameRate = .mtc30
        
    public var midiOutHandler: MIDIOutHandler?
        
    // MARK: - Internal properties
        
    /// Last internal MTC quarter-frame formed. (0...7)
    @ThreadSafeAccess
    public internal(set) var mtcQuarterFrame: UInt8 = 0
        
    /// Internal: flag indicating whether the quarter-frame output stream has already started since the last `locate(to:)` (or since initializing the class if `locate(to:)` has not yet been called).
    @ThreadSafeAccess
    internal var mtcQuarterFrameStreamHasStartedSinceLastLocate = false
        
    /// Internal: track last full-frame message sent to the handler.
    internal var lastTransmitFullFrame: (
        mtcComponents: Timecode.Components,
        mtcFrameRate: MTCFrameRate
    )?
        
    // MARK: - init
        
    /// Initialize and optionally set the handler used when a MTC MIDI message needs transmitting.
    init(
        midiOutHandler: MIDIOutHandler? = nil
    ) {
        self.midiOutHandler = midiOutHandler
    }
        
    // MARK: - methods
        
    /// Locates to a new timecode.
    /// Subframes will be stripped if != 0 since MTC full-frame message resolution is 1 frame.
    ///
    /// - Parameters:
    ///   - timecode: Timecode; frame rate is derived as well.
    ///   - triggerFullFrame: Triggers the MIDI handler to send a full-frame message.
    public func locate(
        to timecode: Timecode,
        transmitFullFrame: FullFrameBehavior = .ifDifferent
    ) {
        locate(
            to: timecode.components,
            frameRate: timecode.frameRate,
            transmitFullFrame: transmitFullFrame
        )
    }
        
    /// Locates to a new timecode.
    /// Subframes will be stripped if != 0 since MTC full-frame message resolution is 1 frame.
    ///
    /// - Parameters:
    ///   - components: Timecode components
    ///   - frameRate: Frame rate
    ///   - triggerFullFrame: Triggers the MIDI handler to send a full-frame message.
    public func locate(
        to components: Timecode.Components,
        frameRate: Timecode.FrameRate? = nil,
        transmitFullFrame: FullFrameBehavior = .ifDifferent
    ) {
        if let unwrappedFrameRate = frameRate {
            setLocalFrameRate(unwrappedFrameRate)
        }
            
        // Step 1: set Encoder's internal MTC components
            
        let scaledFrames = localFrameRate
            .scaledFrames(fromTimecodeFrames: Double(components.f))
            
        var newComponents = components
        newComponents.f = scaledFrames.rawMTCFrames
            
        // sanitize: clear subframes since we're working at 1-frame resolution with timecode display values
        newComponents.sf = 0
            
        setMTCComponents(mtc: newComponents)
        mtcQuarterFrame = scaledFrames.rawMTCQuarterFrames
        mtcQuarterFrameStreamHasStartedSinceLastLocate = false
            
        // Step 2: tell handler to transmit full-frame message if applicable
            
        switch transmitFullFrame {
        case .always:
            sendFullFrameMIDIMessage()
        case .ifDifferent:
            newComponents = convertToFullFrameComponents(
                mtcComponents: newComponents,
                mtcQuarterFrames: scaledFrames.rawMTCQuarterFrames
            )
                
            let newFullFrame = (
                mtcComponents: newComponents,
                mtcFrameRate: mtcFrameRate
            )
            if !mtcIsEqual(lastTransmitFullFrame, newFullFrame) {
                sendFullFrameMIDIMessage()
            }
        case .never:
            break
        }
    }
        
    /// Advances to the next quarter-frame and triggers a quarter-frame MIDI message sent to the MIDI handler.
    ///
    /// - Note: If it is the first time `increment()` is being called since the last call to `locate(to:)` (or since initializing the class), this method will transmit the current quarter-frame without incrementing.
    ///
    /// Used when playhead is moving later in time.
    public func increment() {
        if mtcQuarterFrameStreamHasStartedSinceLastLocate {
            if mtcQuarterFrame < 7 {
                mtcQuarterFrame += 1
            } else {
                guard var tc = try? Timecode(
                    mtcComponents,
                    at: mtcFrameRate.directEquivalentFrameRate
                ) else { return }
                    
                tc.add(wrapping: TCC(f: 2))
                mtcComponents = tc.components
                mtcQuarterFrame = 0
            }
        }
            
        // tell handler to transmit MIDI message
        sendQuarterFrameMIDIMessage()
        mtcQuarterFrameStreamHasStartedSinceLastLocate = true
    }
        
    /// Decrements to the previous quarter-frame and triggers a quarter-frame MIDI message sent to the MIDI handler.
    ///
    /// - Note: If it is the first time `decrement()` is being called since the last call to `locate(to:)` (or since initializing the class), this method will transmit the current quarter-frame without decrementing.
    ///
    /// Used when playhead is moving earlier in time.
    public func decrement() {
        if mtcQuarterFrameStreamHasStartedSinceLastLocate {
            if mtcQuarterFrame > 0 {
                mtcQuarterFrame -= 1
            } else {
                guard var tc = try? Timecode(
                    mtcComponents,
                    at: mtcFrameRate.directEquivalentFrameRate
                ) else { return }
                    
                tc.subtract(wrapping: TCC(f: 2))
                mtcComponents = tc.components
                mtcQuarterFrame = 7
            }
        }
            
        // tell handler to transmit MIDI message
        sendQuarterFrameMIDIMessage()
        mtcQuarterFrameStreamHasStartedSinceLastLocate = true
    }
        
    /// Manually trigger a MIDI handler event to transmit a full-frame message at the current timecode.
    public func sendFullFrameMIDIMessage() {
        let ffMessage = generateFullFrameMIDIMessage()
            
        midiOut(ffMessage.event)
            
        lastTransmitFullFrame = (ffMessage.components, mtcFrameRate)
    }
        
    /// Internal: generates a full-frame message at current position.
    internal func generateFullFrameMIDIMessage() -> (
        event: MIDIEvent,
        components: Timecode.Components
    ) {
        // MTC Full Timecode message
        // (1-frame resolution, does not carry subframe information)
        // ---------------------
        // F0 7F 7F 01 01 hh mm ss ff F7
            
        // hour byte includes base framerate info
        // 0rrhhhhh: Rate (0–3) and hour (0–23).
        // rr == 00: 24 frames/s
        // rr == 01: 25 frames/s
        // rr == 10: 29.97d frames/s (SMPTE drop-frame timecode)
        // rr == 11: 30 frames/s
            
        let newComponents = convertToFullFrameComponents(
            mtcComponents: mtcComponents,
            mtcQuarterFrames: mtcQuarterFrame
        )
            
        let midiEvent = MIDIEvent.universalSysEx7(
            universalType: .realTime,
            deviceID: 0x7F,
            subID1: 0x01,
            subID2: 0x01,
            data: [
                (Byte(newComponents.h) & 0b00011111) + (mtcFrameRate.bitValue << 5),
                Byte(newComponents.m),
                Byte(newComponents.s),
                Byte(newComponents.f)
            ]
        )
            
        return (event: midiEvent, components: newComponents)
    }
        
    /// Internal: triggers a handler event to transmit a quarter-frame message.
    internal func sendQuarterFrameMIDIMessage() {
        midiOut(generateQuarterFrameMIDIMessage())
            
        // invalidate last full-frame information
        lastTransmitFullFrame = nil
    }
        
    /// Internal: generates a quarter-frame message at current position.
    internal func generateQuarterFrameMIDIMessage() -> MIDIEvent {
        // Piece #  Data byte   Significance
        // -------  ---------   ------------
        // 0        0000 ffff   Frame number lsbits
        // 1        0001 000f   Frame number msbit
        // 2        0010 ssss   Seconds lsbits
        // 3        0011 00ss   Seconds msbits
        // 4        0100 mmmm   Minutes lsbits
        // 5        0101 00mm   Minutes msbits
        // 6        0110 hhhh   Hours lsbits
        // 7        0111 0rrh   Rate and hours msbit
            
        var dataByte: Byte = mtcQuarterFrame << 4
            
        switch mtcQuarterFrame {
        case 0b000: // QF 0
            dataByte += (Byte(mtcComponents.f) & 0b00001111)
        case 0b001: // QF 1
            dataByte += (Byte(mtcComponents.f) & 0b00010000) >> 4
        case 0b010: // QF 2
            dataByte += (Byte(mtcComponents.s) & 0b00001111)
        case 0b011: // QF 3
            dataByte += (Byte(mtcComponents.s) & 0b00110000) >> 4
        case 0b100: // QF 4
            dataByte += (Byte(mtcComponents.m) & 0b00001111)
        case 0b101: // QF 5
            dataByte += (Byte(mtcComponents.m) & 0b00110000) >> 4
        case 0b110: // QF 6
            dataByte += (Byte(mtcComponents.h) & 0b00001111)
        case 0b111: // QF 7
            dataByte += ((Byte(mtcComponents.h) & 0b00010000) >> 4)
                + (mtcFrameRate.bitValue << 1)
        default:
            break // will never happen
        }
            
        let midiEvent = MIDIEvent.timecodeQuarterFrame(dataByte: dataByte.toUInt7)
            
        return midiEvent
    }
}
