//
//  LogCategoryFilter.swift
//  Logbook
//
//  Created by Stefan Wieland on 28.11.19.
//  Copyright © 2019 allaboutapps GmbH. All rights reserved.
//

import Foundation

public enum LogCategoryFilter {
    
    case all
    case include([LogCategory])
    case exclude([LogCategory])
    
}
