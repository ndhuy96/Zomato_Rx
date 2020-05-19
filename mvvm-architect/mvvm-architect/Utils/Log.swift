//
//  Log.swift
//  mvvm-architect
//
//  Created by can.khac.nguyen on 5/15/20.
//  Copyright © 2020 sun. All rights reserved.
//

import Foundation

struct Log {
    static func debug(message: String, function: String = #function) {
        #if !NDEBUG
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let date = formatter.string(from: NSDate() as Date)
            print("\(date) Func: \(function) : \(message)")
        #endif
    }
}
