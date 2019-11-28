//
//  FileLogSink.swift
//  Logbook
//
//  Created by Stefan Wieland on 28.11.19.
//  Copyright © 2019 allaboutapps GmbH. All rights reserved.
//

import Foundation

public final class FileLogSink: LogSink {
    
    public let level: LevelMode
    public let categories: [LogCategory]
    private let logFileURL: URL
    private let maxFileSizeInKb: UInt64
    
    public var itemSeparator: String = " "
    public var format: String = LogPlaceholder.defaultLogFormat
    public var dateFormatter: DateFormatter
    
    public init(level: LevelMode, categories: [LogCategory] = [], baseDirectory: URL, fileName: String = "Log", maxFileSize: UInt64 = 20) {
        self.level = level
        self.categories = categories
        self.logFileURL = baseDirectory.appendingPathComponent("\(fileName).log", isDirectory: false)
        self.maxFileSizeInKb = maxFileSize
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .short
        
        if fileManager.fileExists(atPath: logFileURL.path) == false {
            fileManager.createFile(atPath: logFileURL.path, contents: nil, attributes: [.creationDate : Date()])
        }
    }
    
    private let fileManager = FileManager.default
    private lazy var fileHandle: FileHandle? = {
        do {
            let handle = try FileHandle(forWritingTo: logFileURL)
            return handle
        } catch {
            print("Failed to create FileHandle for URL \(logFileURL.absoluteString)")
            print(error)
            return nil
        }
    }()
        
    public func send(_ message: LogMessage) {
        
        let line = createString(for: message)
        
        // append to end of existing file
        guard let fileHandle = fileHandle, let data = line.data(using: .utf8) else { return }
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    }
    
    private func createString(for message: LogMessage) -> String {
        let messages = message.messages.joined(separator: message.separator ?? itemSeparator)
        
        var final = format
        final = final.replacingOccurrences(of: LogPlaceholder.category, with: message.category.prefix ?? "")
        final = final.replacingOccurrences(of: LogPlaceholder.level, with: "\(message.level)")
        final = final.replacingOccurrences(of: LogPlaceholder.date, with: dateFormatter.string(from: message.header.date))
        final = final.replacingOccurrences(of: LogPlaceholder.file, with: message.header.file.name)
        final = final.replacingOccurrences(of: LogPlaceholder.function, with: message.header.function)
        final = final.replacingOccurrences(of: LogPlaceholder.line, with: "\(message.header.line)")
        final = final.replacingOccurrences(of: LogPlaceholder.messages, with: messages)
        final += "\n"
        
        return final
    }
    
    func shouldCreateNewFile(at path: String) -> Bool {
        // TODO: create new file when maximum size is reached ?
        return !fileManager.fileExists(atPath: path)
    }
}