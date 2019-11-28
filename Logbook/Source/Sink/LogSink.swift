//
//  LogSink.swift
//  LogBook
//
//  Created by Stefan Wieland on 25.10.19.
//  Copyright © 2019 aaa - all about apps Gmbh. All rights reserved.
//

import Foundation

public enum LevelMode {
    case fix(LogLevel)
    case min(LogLevel)
}

public protocol LogSink {
    
    var level: LevelMode { get }
    
    var categories: LogCategoryFilter { get }
    
    var dateFormatter: DateFormatter { get set }
    
    var itemSeparator: String { get set }
    
    func send(_ message: LogMessage)
    
}

extension LogSink {
    
    func shouldLevelBeLogged(_ lvl: LogLevel) -> Bool {
        switch level {
        case .fix(let fix):
            return fix.rawValue == lvl.rawValue
        case .min(let min):
            return lvl.rawValue >= min.rawValue
        }
        
    }
    
    func shouldCategoryBeLogged(_ category: LogCategory) -> Bool {
        switch categories {
        case .all:
            return true
        case .include(let cats):
            return cats.contains(category)
        case .exclude(let cats):
            return !cats.contains(category)
        }
    }
    
}
