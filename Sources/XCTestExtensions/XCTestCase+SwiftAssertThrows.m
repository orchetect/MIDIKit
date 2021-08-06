//
//  XCTestCase+SwiftAssertThrows.m
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#import "XCTestCase+SwiftAssertThrows.h"

@implementation XCTestCase(SwiftAssertThrows)

- (void) _XCTAssertThrows:(void (^)(void))block
{
    XCTAssertThrows(block(), "");
}

- (void) _XCTAssertThrows:(void (^)(void))block :(NSString *)message
{
    XCTAssertThrows(block(), @"%@", message);
}

- (void) _XCTAssertThrowsSpecific:(void (^)(void))block :(NSString *)exceptionName :(NSString *)message
{
    BOOL __didThrow = NO;
    @try {
        block();
    }
    @catch (NSException *exception) {
        __didThrow = YES;
        XCTAssertEqualObjects(exception.name, exceptionName, @"%@", message);
    }
    @catch (...) {
        __didThrow = YES;
        XCTFail(@"%@", message);
    }
    
    if (!__didThrow) {
        XCTFail(@"%@", message);
    }
}

@end
