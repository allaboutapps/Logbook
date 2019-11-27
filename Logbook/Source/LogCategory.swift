//
//  LogCategory.swift
//  LogBook
//
//  Created by Stefan Wieland on 25.10.19.
//  Copyright © 2019 aaa - all about apps Gmbh. All rights reserved.
//

import Foundation

public struct LogCategory {

    public let identifier: String
    public let prefix: String?
    
    public init(_ identifier: String, prefix: String?) {
        self.identifier = identifier
        self.prefix = prefix
    }

    public static var `default` = LogCategory("default", prefix: "💡")
    public static var networking = LogCategory("networking", prefix: "🌎")

}

extension LogCategory: Equatable {
 
    public static func == (lhs: LogCategory, rhs: LogCategory) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
}
