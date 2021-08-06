//
//  XCTestCase+SwiftAssertThrows.h
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#import "Foundation/Foundation.h" // @import Foundation;
#import "XCTest/XCTest.h" // @import XCTest;

@interface XCTestCase(SwiftAssertThrows)

- (void) _XCTAssertThrows:(void (^)(void))block;

- (void) _XCTAssertThrows:(void (^)(void))block :(NSString *)message;

- (void) _XCTAssertThrowsSpecific:(void (^)(void))block :(NSString *)name :(NSString *)message;

@end
