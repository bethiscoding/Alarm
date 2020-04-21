//
//  Alarm.swift
//  myAlarm
//
//  Created by Bethany Morris on 4/20/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import Foundation

class Alarm: Codable {
    
    var name: String
    var fireDate: Date
    var enabled: Bool
    var uuid: String
    var fireTimeAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: fireDate)
    }
    
    init(name: String, fireDate: Date, enabled: Bool = true, uuid: String = UUID().uuidString) {
        self.name = name
        self.fireDate = fireDate
        self.enabled = enabled
        self.uuid = uuid
    }
    
} //End of class

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
