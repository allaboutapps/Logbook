//
//  OSLogSink.swift
//  Logbook
//
//  Created by Stefan Wieland on 28.11.19.
//  Copyright © 2019 allaboutapps GmbH. All rights reserved.
//

import Foundation
import os

public class OSLogSink: LogSink {
    
    public var itemSeparator: String = " "
    public private(set) var categories: [LogCategory]
    public private(set) var level: LevelMode
    
    public var format: String = "\(LogPlaceholder.category) \(LogPlaceholder.date) [\(LogPlaceholder.file) \(LogPlaceholder.function): \(LogPlaceholder.line)] - \(LogPlaceholder.messages)"
    public var dateFormatter: DateFormatter
    
    private let customLog: OSLog
    private let isPublic: Bool
    
    public init(level: LevelMode, categories: [LogCategory] = [], isPublic: Bool = false) {
        self.level = level
        self.categories = categories
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .medium
        
        customLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "at.allaboutapps.logbook", category: "Logbook")
        self.isPublic = isPublic
        
    }
    
    public func send(_ message: LogMessage) {
        
        let messages = message.messages.joined(separator: message.separator ?? itemSeparator)
        
        var final = format
        final = final.replacingOccurrences(of: LogPlaceholder.category, with: message.category.prefix ?? "")
        final = final.replacingOccurrences(of: LogPlaceholder.level, with: "")
        final = final.replacingOccurrences(of: LogPlaceholder.date, with: dateFormatter.string(from: message.header.date))
        final = final.replacingOccurrences(of: LogPlaceholder.file, with: message.header.file.name)
        final = final.replacingOccurrences(of: LogPlaceholder.function, with: message.header.function)
        final = final.replacingOccurrences(of: LogPlaceholder.line, with: "\(message.header.line)")
        final = final.replacingOccurrences(of: LogPlaceholder.messages, with: messages)
        
        if isPublic {
            os_log("%{PUBLIC}@", log: customLog, type: message.level.osLogType, final)
        } else {
            os_log("%{PRIVATE}@", log: customLog, type: message.level.osLogType, final)
        }
        
    }
    
}

extension LogLevel {
    
    fileprivate var osLogType: OSLogType {
        switch self {
        case .debug:    return .debug
        case .verbose:  return .info
        case .info:     return .info
        case .warning:  return .info
        case .error:    return .error
        }
    }
    
}
