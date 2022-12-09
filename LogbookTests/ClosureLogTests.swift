//
//  ClosureLogTests.swift
//  LogbookTests
//
//  Created by Stefan Wieland on 21.09.22.
//  Copyright © 2022 allaboutapps GmbH. All rights reserved.
//

import Foundation
import XCTest
@testable import Logbook

struct TestStruct {
    let name = "TestStruct"
}

class TestClass {
    let name = "TestClass"
}

class TestCustomStringConvertible: CustomStringConvertible {
    let name = "TestClass"
    
    var description: String {
        "\(TestCustomStringConvertible.self)(name: \(name))"
    }
}

class TestCustomDebugStringConvertible: CustomDebugStringConvertible {
    
    let name = "TestClass"
    
    var debugDescription: String {
        "\(TestCustomDebugStringConvertible.self)(name: \(name))"
    }
}

enum TestError: Error, LocalizedError, CustomDebugStringConvertible {
    
    case missingData
    
    var errorDescription: String? {
        "Some generic error message"
    }
    
    var debugDescription: String {
        "TestError.missingData"
    }
}

class ClosureLogTests: XCTestCase {
    
    let logbook = Logbook()
    
    func testBasicLog() {
        var logMessage: String = ""
        let expectation = expectation(description: "expectation")
        
        let sink = ClosureLogSink(level: .min(.debug)) { log in
            logMessage = log
            expectation.fulfill()
        }
        
        let logFormat = "\(LogPlaceholder.messages)"
        sink.format = logFormat
        logbook.add(sink: sink)
        
        logbook.debug("Test1")
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertEqual(logMessage, "Test1")
        }
    }
    
    func testStructLog() {
        var logMessage: String = ""
        let expectation = expectation(description: "expectation")
        
        let sink = ClosureLogSink(level: .min(.debug)) { log in
            logMessage = log
            expectation.fulfill()
        }
        
        let logFormat = "\(LogPlaceholder.messages)"
        sink.format = logFormat
        logbook.add(sink: sink)
        
        logbook.debug(TestStruct())
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertEqual(logMessage, "TestStruct(name: \"TestStruct\")")
        }
    }
    
    func testClassLog() {
        var logMessage: String = ""
        let expectation = expectation(description: "expectation")
        
        let sink = ClosureLogSink(level: .min(.debug)) { log in
            logMessage = log
            expectation.fulfill()
        }
        
        let logFormat = "\(LogPlaceholder.messages)"
        sink.format = logFormat
        logbook.add(sink: sink)
        
        logbook.debug(TestClass())
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertEqual(logMessage, "LogbookTests.TestClass")
        }
    }
    
    func testCustomStringConvertibleLog() {
        var logMessage: String = ""
        let expectation = expectation(description: "expectation")
        
        let sink = ClosureLogSink(level: .min(.debug)) { log in
            logMessage = log
            expectation.fulfill()
        }
        
        let logFormat = "\(LogPlaceholder.messages)"
        sink.format = logFormat
        logbook.add(sink: sink)
        
        logbook.debug(TestCustomStringConvertible())
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertEqual(logMessage, "TestCustomStringConvertible(name: TestClass)")
        }
    }
    
    func testCustomDebugStringConvertibleLog() {
        var logMessage: String = ""
        let expectation = expectation(description: "expectation")
        
        let sink = ClosureLogSink(level: .min(.debug)) { log in
            logMessage = log
            expectation.fulfill()
        }
        
        let logFormat = "\(LogPlaceholder.messages)"
        sink.format = logFormat
        logbook.add(sink: sink)
        
        logbook.debug(TestCustomDebugStringConvertible())
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertEqual(logMessage, "TestCustomDebugStringConvertible(name: TestClass)")
        }
    }
 
    func testErrorObjectLog() {
        var logMessage: String = ""
        let expectation = expectation(description: "expectation")
        
        let sink = ClosureLogSink(level: .min(.debug)) { log in
            logMessage = log
            expectation.fulfill()
        }
        
        let logFormat = "\(LogPlaceholder.messages)"
        sink.format = logFormat
        logbook.add(sink: sink)
        
        logbook.debug(TestError.missingData)
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertEqual(logMessage, "TestError.missingData")
        }
    }
    
    func testDetailedClosureSink() {
        let testMessage = "Test Message"
        
        var category: String = ""
        var level: LogLevel = .error
        var message: String = ""
        
        var file: String = ""
        var function: String = ""
        var line: UInt = 0
        
        let expectation = expectation(description: "expectation")
        
        let sink = ClosureLogSink(level: .min(.debug), detailedCallback: { log in
            category = log.category.identifier
            level = log.level
            message = log.messages.first ?? ""
            
            file = log.header.file
            function = log.header.function
            line = log.header.line
            
            expectation.fulfill()
        })
        
        let logFormat = "\(LogPlaceholder.messages)"
        sink.format = logFormat
        logbook.add(sink: sink)
        
        logbook.debug(testMessage, category: .networking)
        
        waitForExpectations(timeout: 3) { _ in
            XCTAssertEqual(category, LogCategory.networking.identifier)
            XCTAssertEqual(level, LogLevel.debug)
            XCTAssertEqual(message, testMessage)
            
            XCTAssertTrue(file.contains("ClosureLogTests.swift"))
            XCTAssertEqual(function, "testDetailedClosureSink()")
            XCTAssertNotEqual(line, 0)
        }
    }
}
