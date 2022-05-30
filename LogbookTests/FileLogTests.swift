//
//  FileLogTests.swift
//  LogbookTests
//
//  Created by Stefan Draskovits on 30.05.22.
//  Copyright © 2022 allaboutapps GmbH. All rights reserved.
//

import XCTest
@testable import Logbook

class FileLogTests: XCTestCase {
    var fileSink: FileLogSink!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        fileSink = FileLogSink(level: .min(.debug), categories: .all, baseDirectory: path, maxFileSize: 100)
        Logbook.add(sink: fileSink!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Logbook.removeAllSinks()
        fileSink = nil
        
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let group = DispatchGroup()
        let count = 1000
        for i in 0...count {
            group.enter()
            DispatchQueue.global().async {
                let message = "test \(i)"
                Logbook.error(message)
                if i % 10 == 0 {
                    self.fileSink.writeCacheToFile()
                }
                group.leave()
            }

            
        }
        
        group.wait()
        
        
    }
    
}
