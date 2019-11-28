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
        
        // log all with min level warning
        Logbook.add(sink: ConsoleLogSink(level: .min(.debug)))
        // log only level error with category .networking
        Logbook.add(sink: ConsoleLogSink(level: .fix(.error), categories: [.networking]))
        
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileSink = FileLogSink(level: .min(.debug), categories: [.fileTest], baseDirectory: path)
            Logbook.add(sink: fileSink)
        }
        
        logToFile()
        
        return true
    }
    
    func logToFile() {
        DispatchQueue.main.asyncAfter (deadline: .now() + .milliseconds(500)) {
            log.debug("Test String", category: .fileTest)
            self.logToFile()
        }
    }
}

// MARK: - Extend Loogbook Categories

extension LogCategory {
    
    static let startup = LogCategory("startup", prefix: "🚦")
    static let fileTest = LogCategory("filetest", prefix: "💾")
    
}
