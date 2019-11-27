//
//  Level.swift
//  LogBook
//
//  Created by Stefan Wieland on 25.10.19.
//  Copyright © 2019 aaa - all about apps Gmbh. All rights reserved.
//

import Foundation

public enum LogLevel: Int {
    
    // Log to be used for debugging purposes
    case debug = 0
    
    // Log something generally unimportant (lowest priority)
    case verbose = 1
    
    // Log something which you are really interested in but which is not an issue or error (normal priority)
    case info = 2
    
    // Log something which may cause big trouble soon (high priority)
    case warning = 3
    
    // Log something which is not working the way it should (highest priority)
    case error = 4
}

extension LogLevel {
    
    var shouldLogAsynchronously: Bool {
        switch self {
        case .debug, .verbose, .info, .warning:
            return true
        case .error:
            return false
        }
    }
    
}
