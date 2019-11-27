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
    
    var prefix: String? { get }
    
    var level: LevelMode { get }
    
    var categories: [LogCategory] { get }
    
    var dateFormatter: DateFormatter { get set }
    
    var itemSeparator: String { get set }
    
    func send(_ message: String)
    
}

//struct Message {
//    let uuid: String
//    let header {
//        time, file, meth, line
//    }
//    let messages: [String]
//}

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
        if categories.isEmpty {
            return true
        } else {
            return self.categories.contains(category)
        }
    }
    
}
