//
//  Core MIDI Connections.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// Internal:
    /// Queries Core MIDI for existing persistent play-thru connections stored in the system matching the specified persistent owner ID.
    ///
    /// To delete them all, see sister function `removeAllSystemThruConnectionsPersistentEntries(:)`.
    ///
    /// - Parameter persistentOwnerID: reverse-DNS domain that was used when the connection was first made
    ///
    /// - Throws: `MIDI.IO.MIDIError.osStatus`
    internal static func getSystemThruConnectionsPersistentEntries(
        matching persistentOwnerID: String
    ) throws -> [MIDI.IO.CoreMIDIThruConnectionRef] {
        
        // set up empty unmanaged data pointer
        var getConnectionList: Unmanaged<CFData> = Unmanaged.passUnretained(Data([]) as CFData)
        
        // get CFData containing list of matching 4-byte UInt32 ID numbers
        let result = MIDIThruConnectionFind(persistentOwnerID as CFString, &getConnectionList)
        
        guard result == noErr else {
            // memory safety: release unmanaged pointer we created
            getConnectionList.release()
            
            throw MIDI.IO.MIDIError.osStatus(result)
        }
        
        // cast to NSData so we can use .getBytes(...)
        let outConnectionList = getConnectionList.takeRetainedValue() as NSData
        
        // get length of data
        let byteCount: CFIndex = CFDataGetLength(outConnectionList)
        
        // aka, byteCount / 4 (MIDIThruConnectionRef is a 4-byte UInt32)
        let itemCount = byteCount / MemoryLayout<MIDIThruConnectionRef>.size
        
        // init array with size
        var thruConnectionArray = [MIDIThruConnectionRef](repeating: 0x00, count: itemCount)
        
        if itemCount > 0 {
            // fill array with constructed values from the data
            outConnectionList.getBytes(&thruConnectionArray, length: byteCount as Int)
        }
        
        return thruConnectionArray
        
    }
    
    /// Internal:
    /// Deletes all system-held Core MIDI MIDI play-thru connections matching an owner ID.
    ///
    /// - Parameter persistentOwnerID: reverse-DNS domain that was used when the connection was first made
    ///
    /// - Throws: `MIDI.IO.MIDIError.osStatus`
    ///
    /// - Returns: Number of deleted matching connections.
    internal static func removeAllSystemThruConnectionsPersistentEntries(
        matching persistentOwnerID: String
    ) throws -> Int {
        
        let getList = try getSystemThruConnectionsPersistentEntries(matching: persistentOwnerID)
        
        var disposeCount = 0
        
        var result = noErr
        
        // iterate through persistent connection list
        for thruConnection in getList {
            
            result = MIDIThruConnectionDispose(thruConnection)
            
            if result != noErr {
                //Log.debug("MIDI: Persistent connections: deletion of connection matching owner ID \(persistentOwnerID.otcQuoted) with number \(thruConnection) failed.")
            } else {
                disposeCount += 1
            }
            
        }
        
        return disposeCount
        
    }
    
}
