//
//  XCTestCase+SwiftAssertThrows.h
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@import Foundation;
@import XCTest; // #import "XCTest/XCTest.h"

@interface XCTestCase(SwiftAssertThrows)

- (void) _XCTAssertThrows
:(void (^)(void))block;

- (void) _XCTAssertThrows
:(void (^)(void))block
:(NSString *)message;

- (void) _XCTAssertThrowsSpecific
:(void (^)(void))block
:(NSString *)name
:(NSString *)message;

@end
