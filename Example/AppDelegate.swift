//
//  AppDelegate.swift
//  Logbook
//
//  Created by Stefan Wieland on 27.11.19.
//  Copyright © 2019 allaboutapps GmbH. All rights reserved.
//

import UIKit
import Logbook

let log = Logbook.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        // Create sink
        let console = ConsoleLogSink(level: .min(.debug), categories: [.networking])
        
        // change date format
        console.dateFormatter = dateFormatter
        
        // change format
        console.format = "\(LogPlaceholder.category) \(LogPlaceholder.date): \(LogPlaceholder.messages)"
        
        // Add sink to Logbook
        Logbook.add(sink: console)
        
        // Override default LogCategory
        LogCategory.default = LogCategory("default", prefix: "💿")
        
        log.debug("default log", application, launchOptions)
        log.debug("didFinishLaunchingWithOptions", category: .startup)
        
        log.error("something went wrong")
        
        return true
    }
}

// MARK: - Extend Loogbook Categories

extension LogCategory {
    
    static let startup = LogCategory("startup", prefix: "🚦")
    
}
