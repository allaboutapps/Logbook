//
//  BaseSink.swift
//  LogBook
//
//  Created by Stefan Wieland on 25.10.19.
//  Copyright © 2019 aaa - all about apps Gmbh. All rights reserved.
//

import Foundation

public class ConsoleLogSink: LogSink {
    
    public var prefix: String?
    public var itemSeparator: String = " "
    public private(set) var categories: [LogCategory]
    public private(set) var level: LevelMode
    public var dateFormatter: DateFormatter
    
    public init(level: LevelMode, categories: [LogCategory] = [], prefix: String? = nil) {
        self.level = level
        self.categories = categories
        self.prefix = prefix
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .none
        self.dateFormatter.timeStyle = .medium
    }
    
    public func send(_ message: String) {
        print(message)
    }

}
