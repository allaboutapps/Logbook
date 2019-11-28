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
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Create sink
        let console = ConsoleLogSink(level: .min(.debug))
        
        // change date format
        console.dateFormatter = dateFormatter
        
        // change format
        console.format = "\(LogPlaceholder.category) \(LogPlaceholder.date): \(LogPlaceholder.messages)"
        
        // Add sink to Logbook
        Logbook.add(sink: console)
        
        // Override default LogCategory
        LogCategory.default = LogCategory("default", prefix: "💿")
        
        
        
        // testmessage
        logToFile()
        
        return true
    }
    
    private func addOSLog() {
        let ossink = OSLogSink(level: .min(.debug), isPublic: false)
        Logbook.add(sink: ossink)
    }
    
    private func addFileLog() {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileSink = FileLogSink(level: .min(.debug), categories: [.fileTest], baseDirectory: path, maxFileSize: 5)
        Logbook.add(sink: fileSink)
    }
    
    private func logToFile() {
        DispatchQueue.main.asyncAfter (deadline: .now() + .milliseconds(500)) {
            log.error("Test String", category: .fileTest)
            self.logToFile()
        }
    }
}

// MARK: - Extend Loogbook Categories

extension LogCategory {
    
    static let startup = LogCategory("startup", prefix: "🚦")
    static let fileTest = LogCategory("filetest", prefix: "💾")
    
}
