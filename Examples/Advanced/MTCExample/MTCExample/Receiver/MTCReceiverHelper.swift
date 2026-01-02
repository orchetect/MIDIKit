//
//  MTCReceiverHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@preconcurrency import Combine
import Foundation
import MIDIKitIO
import MIDIKitSync

/// Object responsible for managing a MTC (MIDI Timecode) receiver port.
///
/// The class is bound to a dedicated background actor (`@MTCActor`) in order to give the MTC objects
/// and handlers a dedicated thread pool since their synchronization operations require high timing precision.
///
/// Observable properties that may result in UI updates are bound to `@MainActor`.
@MTCActor @Observable public final class MTCReceiverHelper {
    @ObservationIgnored public nonisolated(unsafe) weak var midiManager: MIDIManager?
    @ObservationIgnored private var mtcRec: MTCReceiver?
    
    // MARK: - UI State
    
    @MainActor public private(set) var receiverTC = "--:--:--:--"
    @MainActor public private(set) var receiverFR: MTCFrameRate?
    @MainActor public private(set) var receiverState: MTCReceiver.State = .idle
    
    // MARK: - Internal State
    
    @ObservationIgnored private var scheduledLock: Cancellable? = nil
    @ObservationIgnored private var lastSeconds = 0
    
    nonisolated public init(midiManager: MIDIManager? = nil) {
        self.midiManager = midiManager
    }
    
    deinit { teardown() }
}

// MARK: - Static

extension MTCReceiverHelper {
    enum MTCReceiverPort {
        static let name = "MIDIKit MTC In"
        static let tag = "MTCRec"
    }
    
    enum MTCSelfGeneratorConnection {
        static let tag = "MTC Self Gen Connection"
    }
}

// MARK: - Lifecycle

extension MTCReceiverHelper {
    /// Run once after class initialization.
    public func bootstrap(midiManager: MIDIManager? = nil) {
        if let midiManager { self.midiManager = midiManager }
        mtcRec = receiverFactory()
        addPort()
    }
    
    nonisolated public func teardown() {
        // TODO: The commented-out line below is not totally necessary, but we require macOS 15.4 minimum target to gain `isolated deinit { }` support so that this teardown method can be called from deinit.
        // receiverState = .idle
        
        removePort()
        removeSelfGenListenConnection()
    }
}

// MARK: - Receiver Factory

extension MTCReceiverHelper {
    private func receiverFactory() -> MTCReceiver {
        let newReceiver = MTCReceiver(
            initialLocalFrameRate: .fps24,
            syncPolicy: MTCReceiver.SyncPolicy(
                lockFrames: 16,
                dropOutFrames: 10
            )
        )
        
        newReceiver.setTimecodeChangedHandler { [weak self] timecode, event, direction, isFrameChanged in
            Task { @MTCActor in
                guard let self, let mtcRec = self.mtcRec else { return }
                
                Task { @MTCActor in
                    // don't update UI if only subframes have changed
                    guard isFrameChanged else { return }
                    
                    // play a sound when seconds value changes - rudimentary, but works for our needs
                    if timecode.seconds != self.lastSeconds {
                        self.lastSeconds = timecode.seconds
                        await AudioHelper.shared.playClickB()
                    }
                }
                
                Task { @MainActor in
                    self.receiverTC = timecode.stringValue()
                    self.receiverFR = mtcRec.mtcFrameRate
                }
            }
        }
        
        newReceiver.setStateChangedHandler { [weak self] state in
            guard let self else { return }
            
            Task { @MTCActor in
                self.scheduledLock?.cancel()
                self.scheduledLock = nil
                
                switch state {
                case .idle:
                    break
                    
                case let .preSync(lockTime, timecode):
                    let scheduled = DispatchQueue.main.schedule(
                        after: DispatchQueue.SchedulerTimeType(lockTime),
                        interval: .seconds(1),
                        tolerance: .zero,
                        options: DispatchQueue.SchedulerOptions(
                            qos: .userInitiated,
                            flags: [],
                            group: nil
                        )
                    ) { [weak self] in
                        logger.log(">>> LOCAL SYNC: PLAYBACK START @\(timecode)")
                        self?.scheduledLock?.cancel()
                        self?.scheduledLock = nil
                    }
                    
                    self.scheduledLock = scheduled
                    
                case .sync:
                    break
                    
                case .freewheeling:
                    break
                    
                case .incompatibleFrameRate:
                    break
                }
            }
            
            Task { @MainActor in
                self.receiverState = state
                logger.log("MTC Receiver state: \(self.receiverState)")
            }
        }
        
        return newReceiver
    }
}

// MARK: - MIDI I/O

extension MTCReceiverHelper {
    nonisolated var port: MIDIOutput? {
        midiManager?.managedOutputs[MTCReceiverPort.tag]
    }
    
    private func addPort() {
        guard let midiManager, let mtcRec = self.mtcRec else { return }
        
        // don't recreate port if it already exists
        guard port == nil else { return }
            
        // create MTC receiver MIDI endpoint
        do {
            logger.debug("Creating virtual input \"\(MTCReceiverPort.name)\"")
            let udKey = "\(MTCReceiverPort.tag) - Unique ID"
            try midiManager.addInput(
                name: MTCReceiverPort.name,
                tag: MTCReceiverPort.tag,
                uniqueID: .userDefaultsManaged(key: udKey),
                receiver: .weak(mtcRec)
            )
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    private nonisolated func removePort() {
        guard let midiManager else { return }
        
        guard port != nil else { return }
        logger.debug("Removing virtual input \"\(MTCReceiverPort.name)\"")
        midiManager.remove(.input, .withTag(MTCReceiverPort.tag))
    }
    
    // MARK: - Self-Gen Listen
    
    nonisolated var selfGenListenConnection: MIDIInputConnection? {
        midiManager?.managedInputConnections[MTCSelfGeneratorConnection.tag]
    }
    
    public func updateSelfGenListenConnection(state: Bool) {
        if state { addSelfGenListenConnection() } else { removeSelfGenListenConnection() }
    }
    
    private func addSelfGenListenConnection() {
        guard let midiManager, let mtcRec = self.mtcRec else { return }
        
        // don't recreate port if it already exists
        guard selfGenListenConnection == nil else { return }
        
        do {
            logger.debug("Creating input connection with tag \"\(MTCSelfGeneratorConnection.tag)\"")
            try midiManager.addInputConnection(
                to: .outputs(matching: [.name(MTCGeneratorHelper.MTCGeneratorPort.name)]),
                tag: MTCSelfGeneratorConnection.tag,
                receiver: .weak(mtcRec)
            )
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    private nonisolated func removeSelfGenListenConnection() {
        guard let midiManager else { return }
        
        guard selfGenListenConnection != nil else { return }
        logger.debug("Removing input connection with tag \"\(MTCSelfGeneratorConnection.tag)\"")
        midiManager.remove(.inputConnection, .withTag(MTCSelfGeneratorConnection.tag))
    }
}

// MARK: - ViewModel Methods

extension MTCReceiverHelper {
    @MainActor public var localFrameRate: TimecodeFrameRate? {
        get async { await mtcRec?.localFrameRate }
    }
    
    @MainActor public func setLocalFrameRate(_ rate: TimecodeFrameRate?) {
        Task { await mtcRec?.setLocalFrameRate(rate) }
    }
}
