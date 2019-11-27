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
    
    // MARK: Debug
    
    public class func debug(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .debug, separator: separator, file: file, line: line, function: function)
    }
    
    public class func debug(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .debug, file: file, line: line, function: function)
    }
    
    public class func debug(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: .default, level: .debug, file: file, line: line, function: function)
    }
    
    // MARK: Verbose
    
    public class func verbose(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .verbose, separator: separator, file: file, line: line, function: function)
    }
    
    public class func verbose(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .verbose, file: file, line: line, function: function)
    }
    
    public class func verbose(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: .default, level: .verbose, file: file, line: line, function: function)
    }
    
    // MARK: Info
    
    public class func info(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .info, separator: separator, file: file, line: line, function: function)
    }
    
    public class func info(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .info, file: file, line: line, function: function)
    }
    
    public class func info(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: .default, level: .info, file: file, line: line, function: function)
    }
    
    // MARK: Warning
    
    public class func warning(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .warning, separator: separator, file: file, line: line, function: function)
    }
    
    public class func warning(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .warning, file: file, line: line, function: function)
    }
    
    public class func warning(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: .default, level: .warning, file: file, line: line, function: function)
    }
    
    // MARK: Error
    
    public class func error(_ items: Any?..., category: LogCategory, separator: String, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .error, separator: separator, file: file, line: line, function: function)
    }
    
    public class func error(_ items: Any?..., category: LogCategory, file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: category, level: .error, file: file, line: line, function: function)
    }
    
    public class func error(_ items: Any?..., file: FileName = #file, line: UInt = #line, function: String = #function) {
        send(items, category: .default, level: .error, file: file, line: line, function: function)
    }
    
    // MARK: Sinks
    
    public class func add(sink: LogSink) {
        shared.sinks.append(sink)
    }
    
    public class func removeAllSinks() {
        shared.sinks.removeAll()
    }
    
    // MARK: Internal Logic
    
    private class func send(_ items: Any?..., category: LogCategory = .default, level: LogLevel, separator: String? = nil, file: FileName = #file, line: UInt = #line, function: String = #function) {
    
        for sink in shared.sinks {
            guard sink.shouldLevelBeLogged(level) else { continue }
            guard sink.shouldCategoryBeLogged(category) else { continue }
            
            let message: String = ((items.first as? [Any])?.compactMap({ shared.anyString($0) }) ?? [""]).joined(separator: separator ?? sink.itemSeparator)
            
            let formattedMessage = "\(category.prefix ?? "") \(sink.dateFormatter.string(from: Date())) [\(file.name) \(function): \(line)] - \(message)"
            
            if level.shouldLogAsynchronously {
                shared.queue.async {
                    sink.send(formattedMessage)
                }
            } else {
                shared.queue.sync {
                    sink.send(formattedMessage)
                }
            }
            
        }
    }
    
    private func anyString(_ item: Any?) -> String {
        guard let item = item else { return "" }
        
        switch item {
        case let string as String:
            return string
        case let error as Swift.Error:
            return error.localizedDescription
        case let debugStringConvertible as CustomDebugStringConvertible:
            return debugStringConvertible.debugDescription
        case let stringConvertible as CustomStringConvertible:
            return stringConvertible.description
        default:
            return "\(item)"
        }
    }
    
    private init() {}
    private static let shared = Logbook()
    
    private var sinks = [LogSink]()
    private let queue = DispatchQueue(label: "LoggingQueue", qos: .utility)
        
}

// MARK: - Logbook.FileName

private extension Logbook.FileName {
    
    var name: String {
        return components(separatedBy: "/").last ?? ""
    }
    
}
