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
    
    public init(level: LevelMode, categories: [LogCategory] = [], baseDirectory: URL, fileName: String = "Log", maxFileSize: UInt64 = 1024) {
        self.level = level
        self.categories = categories
        self.logFileURL = baseDirectory.appendingPathComponent("\(fileName).log", isDirectory: false)
        self.maxFileSizeInKb = maxFileSize
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .medium
        
        if fileManager.fileExists(atPath: logFileURL.path) == false {
            fileManager.createFile(atPath: logFileURL.path, contents: nil, attributes: [.creationDate : Date()])
        }
    }
    
    deinit {
        fileHandle?.closeFile()
    }
    
    private let fileManager = FileManager.default
    private lazy var fileHandle: FileHandle? = {
        do {
            let handle = try FileHandle(forUpdating: logFileURL)
            return handle
        } catch {
            print("Failed to create FileHandle for URL \(logFileURL.absoluteString)")
            print(error)
            return nil
        }
    }()
    
    private var lineCache: [String] = []
    private let throttleWriteInterval: TimeInterval = 5.0
    
    private var timer: BackgroundTimer?
    
    public func send(_ message: LogMessage) {
        
        lineCache.append(createString(for: message))

        if timer == nil {
            timer = BackgroundTimer(timeInterval: throttleWriteInterval)
            timer?.eventHandler = {
                self.writeCacheToFile()
                self.timer?.suspend()
                self.timer = nil
            }
            timer?.resume()
        }
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
    
}

// MARK: - File

extension FileLogSink {
    
    private func writeCacheToFile() {
        guard !lineCache.isEmpty else { return }
        
        let bytes = bytesToRemove()
        if bytes > 0 {
            removeBytesFromFile(bytes)
        }
        
        let string = lineCache.reduce(into: "", { $0 += $1 })
        lineCache.removeAll()
        
        // append to end of existing file
        guard let fileHandle = fileHandle, let data = string.data(using: .utf8) else { return }
        
        
        
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    }
 
    private func bytesToRemove() -> UInt64 {
        do {
            let attr = try fileManager.attributesOfItem(atPath: logFileURL.path)
            let fileSize = attr[FileAttributeKey.size] as! UInt64
            let maxFileSize = maxFileSizeInKb * 1024
            
            let toRemove: UInt64 = (fileSize > maxFileSize) ? fileSize - maxFileSize: 0
                
            print("FileSize: \(fileSize)")
            print("toRemove: \(toRemove)")
            
            return toRemove
            
        } catch {
            print("Error: \(error)")
            return 0
        }
    }
    
    private func removeBytesFromFile(_ size: UInt64) {
        guard let fileHandle = fileHandle else { return }
        
        fileHandle.seek(toFileOffset: 0)
        
        var data = fileHandle.readDataToEndOfFile()
        data.replaceSubrange(0...Int(size), with: Data())
        
        fileHandle.truncateFile(atOffset: 0)
        fileHandle.seek(toFileOffset: 0)
        fileHandle.write(data)
    }
}
