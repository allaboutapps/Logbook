//
//  FileLogSink.swift
//  Logbook
//
//  Created by Stefan Wieland on 28.11.19.
//  Copyright © 2019 allaboutapps GmbH. All rights reserved.
//

import Foundation

public final class FileLogSink: LogSink {
    
    public let identifier: String
    
    public let level: LevelMode
    public let categories: LogCategoryFilter

    private let logFileURL: URL
    private let maxFileSizeInKb: UInt64

    public var itemSeparator: String = " "
    public var format: String = LogPlaceholder.defaultLogFormat
    public var dateFormatter: DateFormatter
    private let accessQueue = DispatchQueue(label: "LoggingQueue", qos: .utility)

    public init(identifier: String = UUID().uuidString, level: LevelMode, categories: LogCategoryFilter = .all, baseDirectory: URL, fileName: String = "Log", maxFileSize: UInt64 = 1024) {
        self.identifier = identifier
        self.level = level
        self.categories = categories
        logFileURL = baseDirectory.appendingPathComponent("\(fileName).log", isDirectory: false)
        maxFileSizeInKb = maxFileSize
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium

        if fileManager.fileExists(atPath: logFileURL.path) == false {
            fileManager.createFile(atPath: logFileURL.path, contents: nil, attributes: [.creationDate: Date()])
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
            return nil
        }
    }()

    private var lineCache: [String] = []
    private let throttleWriteInterval: TimeInterval = 5.0

    private var timer: BackgroundTimer?

    public func send(_ message: LogMessage) {
        accessQueue.async { [self] in
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
    
    internal func writeCacheToFile() {
        accessQueue.sync { [self] in
            guard !lineCache.isEmpty else { return }

            let string = lineCache.reduce(into: "") { $0 += $1 }

            guard let fileHandle = fileHandle, let data = string.data(using: .utf8) else { return }

            lineCache.removeAll()

            // append to end of existing file
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)

            // reduce file size if needed
            let bytes = bytesToRemove()
            if bytes > 0 {
                removeBytesFromFile(bytes)
            }
        }
    }

    private func bytesToRemove() -> UInt64 {
        do {
            let attr = try fileManager.attributesOfItem(atPath: logFileURL.path)
            let fileSize = attr[FileAttributeKey.size] as! UInt64
            let maxFileSize = maxFileSizeInKb * 1024

            let toRemove: UInt64 = (fileSize > maxFileSize) ? fileSize - maxFileSize : 0

            return toRemove

        } catch {
            return 0
        }
    }

    private func removeBytesFromFile(_ size: UInt64) {
        guard let fileHandle = fileHandle else { return }

        fileHandle.seek(toFileOffset: 0)

        var data = fileHandle.readDataToEndOfFile()
        data.replaceSubrange(0 ... Int(size), with: Data())

        fileHandle.truncateFile(atOffset: 0)
        fileHandle.seek(toFileOffset: 0)
        fileHandle.write(data)
    }
}
