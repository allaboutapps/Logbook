//
//  LogMessage.swift
//  Logbook
//
//  Created by Stefan Wieland on 27.11.19.
//  Copyright © 2019 allaboutapps GmbH. All rights reserved.
//

import Foundation

public struct LogMessage {
    
    public let uuid: String
    public let header: LogMessageHeader
    public let level: LogLevel
    public let category: LogCategory
    public let messages: [String]
    public let separator: String?
    
    init(uuid: String = UUID().uuidString, header: LogMessageHeader, level: LogLevel, category: LogCategory, messages: [String], separator: String?) {
        self.uuid = uuid
        self.header = header
        self.level = level
        self.category = category
        self.messages = messages
        self.separator = separator
    }
}
