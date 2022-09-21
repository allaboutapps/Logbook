//
//  ClosureLogSink.swift
//  Logbook
//
//  Created by Stefan Wieland on 21.09.22.
//  Copyright © 2022 allaboutapps GmbH. All rights reserved.
//

import Foundation

public class ClosureLogSink: LogSink {
    
    public let identifier: String
    
    public let level: LevelMode
    public let categories: LogCategoryFilter
    
    public var itemSeparator: String = " "
    public var format: String = LogPlaceholder.defaultLogFormat
    public var dateFormatter: DateFormatter
    
    private let callback: (String) -> Void
    
    public init(identifier: String = UUID().uuidString, level: LevelMode, categories: LogCategoryFilter = .all, callback: @escaping (String) -> Void) {
        self.identifier = identifier
        self.level = level
        self.categories = categories
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .medium
        self.callback = callback
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
        
        callback(final)
    }

}
