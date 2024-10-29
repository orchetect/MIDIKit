//
//  XCTest Utils.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import XCTest

// Basic Wrappers for XCTest conditions to support inline async expressions
// Note: These kind of workarounds are not necessary with Swift Testing

@_disfavoredOverload
func _XCTAssertEqual<T>(
    _ expression1: @autoclosure () async throws -> T,
    _ expression2: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async rethrows where T : Equatable {
    let exp1 = try await expression1()
    let exp2 = try await expression2()
    XCTAssertEqual(exp1, exp2, message(), file: file, line: line)
}

func _XCTAssertEqual<T>(
    _ expression1: @autoclosure () async throws -> T,
    _ expression2: @autoclosure () async throws -> T,
    accuracy: T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async rethrows where T : FloatingPoint {
    let exp1 = try await expression1()
    let exp2 = try await expression2()
    XCTAssertEqual(exp1, exp2, accuracy: accuracy, message(), file: file, line: line)
}

func _XCTAssertEqual<T>(
    _ expression1: @autoclosure () async throws -> T,
    _ expression2: @autoclosure () async throws -> T,
    accuracy: T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async rethrows where T : Numeric {
    let exp1 = try await expression1()
    let exp2 = try await expression2()
    XCTAssertEqual(exp1, exp2, accuracy: accuracy, message(), file: file, line: line)
}

public func _XCTAssertNil(
    _ expression: @autoclosure () async throws -> Any?,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async rethrows {
    let exp = try await expression()
    XCTAssertNil(exp, message(), file: file, line: line)
}

public func _XCTAssertNotNil(
    _ expression: @autoclosure () async throws -> Any?,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async rethrows {
    let exp = try await expression()
    XCTAssertNotNil(exp, message(), file: file, line: line)
}

public func _XCTAssertTrue(
    _ expression: @autoclosure () async throws -> Bool,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async rethrows {
    let exp = try await expression()
    XCTAssertTrue(exp, message(), file: file, line: line)
}

public func _XCTAssertFalse(
    _ expression: @autoclosure () async throws -> Bool,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async rethrows {
    let exp = try await expression()
    XCTAssertFalse(exp, message(), file: file, line: line)
}
