//
//  LogBook.swift
//  LogBook
//
//  Created by Stefan Wieland on 25.10.19.
//  Copyright © 2019 aaa - all about apps Gmbh. All rights reserved.
//

import Foundation

// MARK: - CustomLogPrefixConvertible

public class Logbook {
    
    public typealias FileName = String
    
    public init() {}
    private static let shared = Logbook()
    
    private var sinks = [LogSink]()
    private let queue = DispatchQueue(label: "LoggingQueue", qos: .utility)
        
}

extension Logbook.FileName {
    var name: String { components(separatedBy: "/").last ?? "" }
}

// MARK: - Private

extension Logbook {
    
    private func anyToString(_ item: Any?) -> String {
        guard let unwrappedItem = item else { return "" }
        
        switch unwrappedItem {
        case let string as String:
            return string
        case let error as Swift.Error:
            return error.localizedDescription
//        case let opt as Optional<Any>:
//            guard let noOpt = opt else { return "" }
//            return String(describing: noOpt)
        case let debugStringConvertible as CustomDebugStringConvertible:
            return debugStringConvertible.debugDescription
        case let stringConvertible as CustomStringConvertible:
            return stringConvertible.description
        default:
            return String(describing: item)
        }
    }
    
    private func send(_ items: Any?..., category: LogCategory = .default, level: LogLevel, separator: String? = nil, file: FileName = #file, line: UInt = #line, function: String = #function) {
        for sink in sinks {
            guard sink.shouldLevelBeLogged(level) else { continue }
            guard sink.shouldCategoryBeLogged(category) else { continue }
            
            let messages: [String] = ((items.first as? [Any])?.compactMap({ anyToString($0) }) ?? [""])
            
            let header = LogMessageHeader(date: Date(), file: file, line: line, function: function)
            let message = LogMessage(header: header, level: level, category: category, messages: messages, separator: separator)
            
            if level.shouldLogAsynchronously {
                queue.async {
                    sink.send(message)
                }
            } else {
                queue.sync {
                    sink.send(message)
                }
            }
        }
    }
}

// MARK: - Public Instance Methods
    
extension Logbook {
    
    public func debug(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .debug, separator: separator, file: file, line: line, function: function)
    }
    
    public func debug(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .debug, file: file, line: line, function: function)
    }
    
    public func debug(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: .default, level: .debug, file: file, line: line, function: function)
    }
    
    // MARK: Verbose
    
    public func verbose(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .verbose, separator: separator, file: file, line: line, function: function)
    }
    
    public func verbose(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .verbose, file: file, line: line, function: function)
    }
    
    public func verbose(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: .default, level: .verbose, file: file, line: line, function: function)
    }
    
    // MARK: Info
    
    public func info(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .info, separator: separator, file: file, line: line, function: function)
    }
    
    public func info(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .info, file: file, line: line, function: function)
    }
    
    public func info(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: .default, level: .info, file: file, line: line, function: function)
    }
    
    // MARK: Warning
    
    public func warning(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .warning, separator: separator, file: file, line: line, function: function)
    }
    
    public func warning(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .warning, file: file, line: line, function: function)
    }
    
    public func warning(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: .default, level: .warning, file: file, line: line, function: function)
    }
    
    // MARK: Error
    
    public func error(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .error, separator: separator, file: file, line: line, function: function)
    }
    
    public func error(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .error, file: file, line: line, function: function)
    }
    
    public func error(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: .default, level: .error, file: file, line: line, function: function)
    }
    
    // MARK: Sinks
    
    public func add(sink: LogSink) {
        sinks.append(sink)
    }
    
    public func removeSink(_ sink: LogSink) {
        guard let index = sinks.firstIndex(where: { $0.identifier == sink.identifier }) else { return }
        sinks.remove(at: index)
    }
    
    public func removeAllSinks() {
        sinks.removeAll()
    }
    
}

// MARK: - Public Static Methods

extension Logbook {
    
    // MARK: Debug
    
    public class func debug(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.debug(items, category: category, separator: separator, file: file, line: line, function: function)
    }
    
    public class func debug(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.debug(items, category: category, file: file, line: line, function: function)
    }
    
    public class func debug(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.debug(items, file: file, line: line, function: function)
    }
    
    // MARK: Verbose
    
    public class func verbose(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.verbose(items, category: category, separator: separator, file: file, line: line, function: function)
    }
    
    public class func verbose(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.verbose(items, category: category, file: file, line: line, function: function)
    }
    
    public class func verbose(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.verbose(items, file: file, line: line, function: function)
    }
    
    // MARK: Info
    
    public class func info(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.info(items, category: category, separator: separator, file: file, line: line, function: function)
    }
    
    public class func info(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.info(items, category: category, file: file, line: line, function: function)
    }
    
    public class func info(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.info(items, file: file, line: line, function: function)
    }
    
    // MARK: Warning
    
    public class func warning(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.warning(items, category: category, separator: separator, file: file, line: line, function: function)
    }
    
    public class func warning(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.warning(items, category: category, file: file, line: line, function: function)
    }
    
    public class func warning(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.warning(items, file: file, line: line, function: function)
    }
    
    // MARK: Error
    
    public class func error(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.error(items, category: category, separator: separator, file: file, line: line, function: function)
    }
    
    public class func error(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.error(items, category: category, file: file, line: line, function: function)
    }
    
    public class func error(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.error(items, file: file, line: line, function: function)
    }
    
    // MARK: Sinks
    
    public class func add(sink: LogSink) {
        shared.sinks.append(sink)
    }
    
    public class func removeSink(_ sink: LogSink) {
        guard let index = shared.sinks.firstIndex(where: { $0.identifier == sink.identifier }) else { return }
        shared.sinks.remove(at: index)
    }
    
    public class func removeAllSinks() {
        shared.sinks.removeAll()
    }
    
    // MARK: Internal Logic
    
    private class func send(_ items: Any?..., category: LogCategory = .default, level: LogLevel, separator: String? = nil, file: FileName = #file, line: UInt = #line, function: String = #function) {
        shared.send(items, category: category, level: level, separator: separator, file: file, line: line, function: function)
    }
    
}
