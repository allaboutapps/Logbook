//
//  BaseSink.swift
//  LogBook
//
//  Created by Stefan Wieland on 25.10.19.
//  Copyright © 2019 aaa - all about apps Gmbh. All rights reserved.
//

import Foundation

public class ConsoleLogSink: LogSink {
    
    public var itemSeparator: String = " "
    public private(set) var categories: [LogCategory]
    public private(set) var level: LevelMode
    
    public var format: String = LogPlaceholder.defaultLogFormat
    public var dateFormatter: DateFormatter
    
    public init(level: LevelMode, categories: [LogCategory] = []) {
        self.level = level
        self.categories = categories
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .medium
    }
    
    public func send(_ message: LogMessage) {
        
        let messages = message.messages.joined(separator: message.separator ?? itemSeparator)
        
        var final = format
        final = final.replacingOccurrences(of: LogPlaceholder.category, with: message.category.prefix ?? "")
        final = final.replacingOccurrences(of: LogPlaceholder.level, with: "\(message.level)")
        final = final.replacingOccurrences(of: LogPlaceholder.date, with: dateFormatter.string(from: message.header.date))
        final = final.replacingOccurrences(of: LogPlaceholder.file, with: message.header.file.name)
        final = final.replacingOccurrences(of: LogPlaceholder.function, with: message.header.function)
        final = final.replacingOccurrences(of: LogPlaceholder.line, with: "\(message.header.line)")
        final = final.replacingOccurrences(of: LogPlaceholder.messages, with: messages)
        
        print(final)
    }

}
