//
//  DateFormatter.swift
//  myAlarm
//
//  Created by Bethany Morris on 4/20/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import Foundation

class DateFormatter: Formatter {
    
    let dateFormatter = DateFormatter()
    dateFormatter.
    dateFormatter.timeStyle = .short

    let date = Date(timeIntervalSinceReferenceDate: 118800)

    // US English Locale (en_US)
    dateFormatter.locale = Locale(identifier: "en_US")
    print(dateFormatter.string(from: date)) // Jan 2, 2001
    
} //End of class

