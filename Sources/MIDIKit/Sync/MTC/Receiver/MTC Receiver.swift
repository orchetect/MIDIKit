//
//  MTC Receiver.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import OTCore
import TimecodeKit

// MARK: - Receiver

extension MIDI.MTC {
	
	/// MTC sync receiver wrapper for `MTC.Decoder`.
	///
	/// - Note: Note the following:
	/// - A running MTC data stream (during playback) only updates the frame number every 2 frames, so this data stream should not be relied on for deriving exact frame position, but rather as a mechanism for displaying running timecode to the user on screen or synchronizing playback to the incoming MTC data stream.
	/// - MTC full frame messages (which only some DAWs support) will however transmit frame-accurate timecodes when scrubbing or locating to different times.
	public class Receiver {
		
		// MARK: - Public properties
		
		public private(set) var name: String
		
		@MIDI.AtomicAccess public private(set) var state: State = .idle {
			didSet {
				if state != oldValue {
					let newState = state
					DispatchQueue.main.async {
						self.stateChangedHandler?(newState)
					}
				}
			}
		}
		
		/// Property updated whenever incoming MTC timecode changes.
		public private(set) var timecode: Timecode
		
		/// The frame rate the local system is using.
		/// Remember to also set this any time the local frame rate changes so the receiver can interpret the incoming MTC accordingly.
		public var localFrameRate: Timecode.FrameRate? {
			get {
				decoder.localFrameRate
			}
			set {
				decoder.localFrameRate = newValue
			}
		}
		
		/// The SMPTE frame rate (24, 25, 29.97d, or 30) that was last received by the receiver.
		/// 
		/// This property should only be inspected purely for developer informational or diagnostic purposes. For production code or any logic related to MTC, it should be ignored -- only the `localFrameRate` property is used for automatic validation and scaling of incoming timecode.
		public var mtcFrameRate: MTCFrameRate {
			decoder.mtcFrameRate
		}
		
		/// Status of the direction of MTC quarter-frames received
		public var direction: Direction {
			decoder.direction
		}
		
		/// Behavior governing how locking occurs prior to chase
		@MIDI.AtomicAccess public var syncPolicy: SyncPolicy = SyncPolicy()
		
		
		// MARK: - Stored closures
		
		/// Called when a meaningful change to the timecode has occurred which would require its display to be updated.
		///
		/// Implement this closure for when you only want to display timecode and do not need to sync to MTC.
		internal var timecodeChangedHandler: ((_ timecode: Timecode,
											   _ event: MessageType,
											   _ direction: Direction,
											   _ displayNeedsUpdate: Bool) -> Void)? = nil
		
		/// Sets the closure called when a meaningful change to the timecode has occurred which would require its display to be updated.
		///
		/// Implement this closure for when you only want to display timecode and do not need to sync to MTC.
		public func setTimecodeChangedHandler(_ handler: ((_ timecode: Timecode,
														   _ event: MessageType,
														   _ direction: Direction,
														   _ displayNeedsUpdate: Bool) -> Void)?) {
			
			timecodeChangedHandler = handler
			
		}
		
		/// Called when the MTC receiver's state changes
		internal var stateChangedHandler: ((_ state: State) -> Void)? = nil
		
		/// Sets the closure called when the MTC receiver's state changes
		public func setStateChangedHandler(_ handler: ((_ state: State) -> Void)?) {
			
			stateChangedHandler = handler
			
		}
		
		
		// MARK: - Init
		
		/// Initialize a new MTC Receiver instance.
		///
		/// - Parameters:
		///   - name: optionally supply a simple, unique alphanumeric name for the instance, used internally to identify the dispatch thread; random UUID will be used if `nil`
		///   - initialLocalFrameRate: set an initial local frame rate
		///   - syncPolicy: set the MTC sync policy
		///   - timecodeChanged: handle timecode change callbacks, pass `nil` if not needed
		///   - stateChanged: handle receiver state change callbacks, pass `nil` if not needed
		public init(
			name: String? = nil,
			initialLocalFrameRate: Timecode.FrameRate? = nil,
			syncPolicy: SyncPolicy? = nil,
			timecodeChanged: ((_ timecode: Timecode,
							   _ event: MessageType,
							   _ direction: Direction,
							   _ displayNeedsUpdate: Bool) -> Void)? = nil,
			stateChanged: ((_ state: Receiver.State) -> Void)? = nil
		) {
			
			// handle init arguments
			
			let name = name ?? UUID().uuidString
			
			self.name = name
			
			timecode = Timecode(at: initialLocalFrameRate ?? ._30)
			
			if let syncPolicy = syncPolicy {
				self.syncPolicy = syncPolicy
			}
			
			// queue
			
			queue = DispatchQueue(label: "midikit.mtcreceiver.\(name)",
								  qos: .userInteractive)
			
			// set up decoder reset timer
			// we're accounting for the largest reasonable interval of time we are willing to wait until we assume non-contiguous MTC stream has stopped or failed
			// it would be reasonable to allow for the slowest frame rate (23.976fps) and round up by a modest margin:
			// 1 frame @ 23.976 = 41.7... ms
			// 1 quarter-frame = 41.7/4 = 10.4... ms
			// Timer checking twice per QF = ~5.0ms intervals = 200Hz
			
			timer = MIDI.SafeDispatchTimer(rate: .hertz(200.0),
										   queue: queue,
										   eventHandler: { })
			
			timer.setEventHandler { [weak self] in
				
				self?.timerFired()
				
			}
			
			// decoder setup
			
			decoder = Decoder(initialLocalFrameRate: initialLocalFrameRate)
			
			decoder.setTimecodeChangedHandler { timecode,
												messageType,
												direction,
												displayNeedsUpdate in
				
				self.timecodeDidChange(to: timecode,
									   event: messageType,
									   direction: direction,
									   displayNeedsUpdate: displayNeedsUpdate)
				
			}
			
			// updates decoder's localFrameRate if not already updated
			localFrameRate = initialLocalFrameRate
			
			// store handler closures
			
			timecodeChangedHandler = timecodeChanged
			stateChangedHandler = stateChanged
			
		}
		
		
		// MARK: - Queue (internal)
		
		/// Maintain a high-priority internal thread
		internal var queue: DispatchQueue
		
		
		// MARK: - Decoder (internal)
		
		internal var decoder: Decoder!
		
		internal var timeLastQuarterFrameReceived: timespec = timespec()
		
		internal var freewheelPreviousTimecode: Timecode = Timecode(at: ._30)
		internal var freewheelSequentialFrames = 0
		
		
		// MARK: - Timer (internal)
		
		internal let timer: MIDI.SafeDispatchTimer
		
		/// Internal: Fired from our timer object.
		internal func timerFired() {
			
			// this will be called by the timer which operates on our internal queue, so we don't need to wrap this in queue.async { }
			
			let timeNow = clock_gettime_monotonic_raw()
			
			let clockDiff = timeNow - timeLastQuarterFrameReceived
			
			// increment state from preSync to chasing once requisite frames have elapsed
			
			switch state {
			case .preSync(_, let prTimecode):
				if timecode >= prTimecode {
					state = .sync
				}
			default: break
			}
			
			// timer timeout condition
			let continuousQFTimeout = timespec(tv_sec: 0,
											   tv_nsec: 50_000_000)
			
			let dropOutFramesDuration =
				Timecode(wrapping: TCC(f: syncPolicy.dropOutFrames),
						 at: localFrameRate ?? ._30)
				.realTimeValue
			
			let freewheelTimeout = timespec(seconds: dropOutFramesDuration)
			
			// if >20ms window of time since last quarter frame, assume MTC message stream has been stopped/interrupted or being received at a speed less than realtime (ie: when Pro Tools plays back at half-speed) and reset our internal tracker
			if clockDiff > continuousQFTimeout && clockDiff < freewheelTimeout {
				
				decoder.resetQFBuffer()
				
				state = .freewheeling
				
			} else if clockDiff > freewheelTimeout {
				
				state = .idle
				timer.stop()
				
			}
			
		}
		
		
		// MARK: - Public methods
		
		/// (Async) Incoming MIDI messages
		public func midiIn(event: MIDI.Event) {
			
			// The decoder's midiIn can trigger handler callbacks as a result, which will in turn all be executed on the queue
			
			queue.async {
				self.decoder.midiIn(event: event)
			}
			
		}
		
	}
	
}


// MARK: - Handler Methods

extension MIDI.MTC.Receiver {
	
	/// Internal: MTC.Decoder handler proxy method
	internal func timecodeDidChange(to incomingTC: Timecode,
									event: MIDI.MTC.MessageType,
									direction: MIDI.MTC.Direction,
									displayNeedsUpdate: Bool) {
		
		// determine frame rate compatibility
		var frameRateIsCompatible = true
		
		if let localFrameRate = localFrameRate,
		   !incomingTC.frameRate.isCompatible(with: localFrameRate) {
			frameRateIsCompatible = false
		}
		
		if event == .fullFrame,
		   !frameRateIsCompatible {
			return
		}
		
		if event == .quarterFrame {
			
			// assess if MTC frame rate and local frame rate are compatible with each other
			if !frameRateIsCompatible {
				state = .incompatibleFrameRate
			} else if state == .incompatibleFrameRate {
				state = .freewheeling
			}
			
			// log quarter-frame timestamp
			let timeNow = clock_gettime_monotonic_raw()
			timeLastQuarterFrameReceived = timeNow
			
			// update state
			if state == .idle {
				state = .freewheeling
			}
			
			// start timer
			if !timer.running {
				timer.restart()
			}
			
		}
		
		// update class property
		timecode = incomingTC
		
		// notify handler to update display
		DispatchQueue.main.async {
			self.timecodeChangedHandler?(incomingTC,
										 event,
										 direction,
										 displayNeedsUpdate)
		}
		
		if event == .quarterFrame {
			
			// update state
			if state == .freewheeling {
				
				if incomingTC - freewheelPreviousTimecode
					== Timecode(TCC(f: 1), at: localFrameRate ?? incomingTC.frameRate)
				{
					freewheelSequentialFrames += 1
				} else {
					freewheelSequentialFrames = 0
				}
				
			}
			
			if state == .freewheeling,
			   freewheelSequentialFrames <= syncPolicy.lockFrames {
				
				// enter preSync phase
				
				freewheelSequentialFrames = 0
				
				// calculate time until lock
				
				let preSyncFrames = Timecode(wrapping: TCC(f: syncPolicy.lockFrames),
											 at: localFrameRate ?? incomingTC.frameRate)
				let prerollDuration = Int(preSyncFrames.realTimeValue * 1_000_000) // microseconds
				
				let now = DispatchTime.now() // same as DispatchTime(rawValue: mach_absolute_time())
				let durationUntilLock = DispatchTimeInterval.microseconds(prerollDuration)
				let futureTime = now + durationUntilLock
				
				let lockTimecode = incomingTC.advanced(by: syncPolicy.lockFrames)
				
				// change receiver state
				
				state = .preSync(predictedLockTime: futureTime,
								 lockTimecode: lockTimecode)
				
			} else if freewheelSequentialFrames >= syncPolicy.lockFrames {
				
				// enter chasing phase
				
				switch state {
				case .preSync(_, _):
					state = .sync
				default: break
				}
				
			}
			
			// update registers
			freewheelPreviousTimecode = incomingTC
			
		}
		
	}
	
}
