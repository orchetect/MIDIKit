//
//  DataReader Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

@testable import MIDIKit
import XCTest

final class DataReaderTests: XCTestCase {
    
    // MARK: - Data storage starting with index 0
    
    func testRead() {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        // .read - byte by byte
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.readPosition, 0)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x02]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x03]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x04]))
            XCTAssertEqual(dr.read(bytes: 1), nil)
        }
        
        // .read - nil read - return all remaining bytes
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.read(), data)
            XCTAssertEqual(dr.read(bytes: 1), nil)
        }
        
        // .read - zero count read - return empty data, not nil
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.read(bytes: 0), Data())
        }
        
        // .read - read overflow - return nil
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.read(bytes: 5), nil)
        }
    }
    
    func testNonAdvancingRead() {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        // .nonAdvancingRead - nil read - return all remaining bytes
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.nonAdvancingRead(), data)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
        
        // .nonAdvancingRead - read byte counts
        do {
            let dr = DataReader(data)
            
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 2), Data([0x01, 0x02]))
        }
        
        // .nonAdvancingRead - read overflow - return nil
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 5), nil)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
    }
    
    func testAdvanceBy() {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        // advanceBy
        do {
            var dr = DataReader(data)
            
            dr.advanceBy(1)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x02]))
        }
    }
    
    func tesReset() {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        
        // reset
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.read(bytes: 2), Data([0x02, 0x03]))
            dr.reset()
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
    }
    
    // MARK: - Data storage starting with index >0
    
    func testRead_DataIndicesOffset() {
        let rawData = Data([0x00, 0x00, 0x00,
                            0x01, 0x02, 0x03, 0x04])
        let data = rawData[3 ... 6]
        
        // .read - byte by byte
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.readPosition, 0)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x02]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x03]))
            XCTAssertEqual(dr.read(bytes: 1), Data([0x04]))
            XCTAssertEqual(dr.read(bytes: 1), nil)
        }
        
        // .read - nil read - return all remaining bytes
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.read(), data)
            XCTAssertEqual(dr.read(bytes: 1), nil)
        }
        
        // .read - zero count read - return empty data, not nil
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.read(bytes: 0), Data())
        }
        
        // .read - read overflow - return nil
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.read(bytes: 5), nil)
        }
    }
    
    func testNonAdvancingRead_DataIndicesOffset() {
        let rawData = Data([0x00, 0x00, 0x00,
                            0x01, 0x02, 0x03, 0x04])
        let data = rawData[3 ... 6]
        
        // .nonAdvancingRead - nil read - return all remaining bytes
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.nonAdvancingRead(), data)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
        
        // .nonAdvancingRead - read byte counts
        do {
            let dr = DataReader(data)
            
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 2), Data([0x01, 0x02]))
        }
        
        // .nonAdvancingRead - read overflow - return nil
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.nonAdvancingRead(bytes: 5), nil)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
    }
    
    func testAdvanceBy_DataIndicesOffset() {
        let rawData = Data([0x00, 0x00, 0x00,
                            0x01, 0x02, 0x03, 0x04])
        let data = rawData[3 ... 6]
        
        // advanceBy
        do {
            var dr = DataReader(data)
            
            dr.advanceBy(1)
            XCTAssertEqual(dr.read(bytes: 1), Data([0x02]))
        }
    }
    
    func tesReset_DataIndicesOffset() {
        let rawData = Data([0x00, 0x00, 0x00,
                            0x01, 0x02, 0x03, 0x04])
        let data = rawData[3 ... 6]
        
        
        // reset
        do {
            var dr = DataReader(data)
            
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
            XCTAssertEqual(dr.read(bytes: 2), Data([0x02, 0x03]))
            dr.reset()
            XCTAssertEqual(dr.read(bytes: 1), Data([0x01]))
        }
    }
    
}

#endif
