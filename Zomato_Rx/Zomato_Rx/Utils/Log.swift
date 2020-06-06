//
//  Log.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/6/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

enum Log {
    static func debug(message: String, function: String = #function) {
        #if !NDEBUG
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let date = formatter.string(from: NSDate() as Date)
            print("\(date) Func: \(function) : \(message)")
        #endif
    }
}
