//
//  BaseSink.swift
//  LogBook
//
//  Created by Stefan Wieland on 25.10.19.
//  Copyright © 2019 aaa - all about apps Gmbh. All rights reserved.
//

import Foundation

public class ConsoleLogSink: LogSink {
    
    public let identifier: String
    
    public let level: LevelMode
    public let categories: LogCategoryFilter
    
    public var itemSeparator: String = " "
    public var format: String = LogPlaceholder.defaultLogFormat
    public var dateFormatter: DateFormatter
    
    public init(identifier: String = UUID().uuidString, level: LevelMode, categories: LogCategoryFilter = .all) {
        self.identifier = identifier
        self.level = level
        self.categories = categories
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .medium
    }
    
    public func send(_ message: LogMessage) {
        
        let messages = message.messages.joined(separator: message.separator ?? itemSeparator)
        
        var formattedMessage = format
        formattedMessage = formattedMessage.replacingOccurrences(of: LogPlaceholder.category, with: message.category.prefix ?? "")
        formattedMessage = formattedMessage.replacingOccurrences(of: LogPlaceholder.level, with: "\(message.level)")
        formattedMessage = formattedMessage.replacingOccurrences(of: LogPlaceholder.date, with: dateFormatter.string(from: message.header.date))
        formattedMessage = formattedMessage.replacingOccurrences(of: LogPlaceholder.file, with: message.header.file.name)
        formattedMessage = formattedMessage.replacingOccurrences(of: LogPlaceholder.function, with: message.header.function)
        formattedMessage = formattedMessage.replacingOccurrences(of: LogPlaceholder.line, with: "\(message.header.line)")
        formattedMessage = formattedMessage.replacingOccurrences(of: LogPlaceholder.messages, with: messages)
        
        print(formattedMessage)
    }

}
