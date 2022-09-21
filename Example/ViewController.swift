//
//  ViewController.swift
//  Logbook
//
//  Created by Stefan Wieland on 27.11.19.
//  Copyright © 2019 allaboutapps GmbH. All rights reserved.
//

import UIKit
import Logbook

class TestClass {
    let name = "TestClass"
    
    var description: String {
      return "\(self)(name: \(name))"
    }
}

struct TestStruct {
    let name = "TestStruct"
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("setup instance of Logbook")
        let logbookInstance = Logbook()
        logbookInstance.add(sink: ConsoleLogSink(level: .min(.debug)))
    
        logbookInstance.debug("Test classes", TestClass(), category: .instanceTest, separator: " / ")
        logbookInstance.debug("Test structs", TestStruct(), category: .instanceTest, separator: " / ")
    }


}

extension LogCategory {
    
    static let instanceTest = LogCategory("instanceTest", prefix: "🤖")
    
}
