//
//  LogMessageHeader.swift
//  Logbook
//
//  Created by Stefan Wieland on 27.11.19.
//  Copyright © 2019 allaboutapps GmbH. All rights reserved.
//

import Foundation

public struct LogMessageHeader {
    
    public let date: Date
    public let file: Logbook.FileName
    public let line: UInt
    public let function: String
    
}
