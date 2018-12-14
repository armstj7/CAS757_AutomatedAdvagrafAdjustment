//
//  File.swift
//  AdvagrafApp
//
//  Created by Steven Armstrong on 2018-12-12.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import Foundation

func getNow() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    
    let now = formatter.string(from: date)
    return now
}

func getNowTimestamp() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a"
    
    let now = formatter.string(from: date)
    return now
}
