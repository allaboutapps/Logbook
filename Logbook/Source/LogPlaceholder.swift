//
//  LogPlaceholder.swift
//  Logbook
//
//  Created by Stefan Wieland on 27.11.19.
//  Copyright © 2019 allaboutapps GmbH. All rights reserved.
//

import Foundation

public struct LogPlaceholder {
    
    public static let sink = "{##}sink{##}"
    public static let level = "{##}level{##}"
    public static let category = "{##}category{##}"
    public static let date = "{##}date{##}"
    public static let file = "{##}file{##}"
    public static let function = "{##}function{##}"
    public static let line = "{##}line{##}"
    public static let messages = "{##}messages{##}"
    
}

public extension LogPlaceholder {
    
    static var defaultLogFormat: String {
        return "\(LogPlaceholder.category) [\(LogPlaceholder.level)] \(LogPlaceholder.date) [\(LogPlaceholder.file) \(LogPlaceholder.function): \(LogPlaceholder.line)] - \(LogPlaceholder.messages)"
    }
    
}
