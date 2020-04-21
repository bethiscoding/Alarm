//
//  AlarmController.swift
//  myAlarm
//
//  Created by Bethany Morris on 4/20/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

protocol AlarmControllerDelegate: class {
}

extension AlarmControllerDelegate {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "Your alarm named \(alarm.name) is going off!"
        //notificationContent.subtitle = ""
        notificationContent.badge = 1
        notificationContent.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelUserNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
    
//    func displayDismissAlertController(for alarm: Alarm) {
//        let dismissAlertController  = UIAlertController(title: "Your alarm named \(alarm.name) is going off!", message: nil, preferredStyle: .alert)
//
//        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
//        dismissAlertController.addAction(dismissAction)
//
//        present
//    }
} //End of protocol

class AlarmController {
    
    // MARK: - Singleton
    
    static let sharedInstance = AlarmController()
    
    // MARK: - Source of Truth
    
    var myAlarms: [Alarm] = []
    
    // MARK: - Methods
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotification(for: alarm)
        }
    }
    
    // MARK: - CRUD Methods
    
    func createAlarm(name: String, fireDate: Date, enabled: Bool) {
        let newAlarm = Alarm(name: name, fireDate: fireDate)
        myAlarms.append(newAlarm)
        scheduleUserNotifications(for: newAlarm)
        saveToPersistentStore()
    }
    
    func updateAlarm(alarm: Alarm, name: String, fireDate: Date, enabled: Bool) {
        cancelUserNotification(for: alarm)
        
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        scheduleUserNotifications(for: alarm)
        
        saveToPersistentStore()
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard let indexToDelete = myAlarms.firstIndex(of: alarm) else { return }
        cancelUserNotification(for: alarm)
        myAlarms.remove(at: indexToDelete)
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    
    // Create the url where we are saving our data
    func createFileURL() -> URL {
        /// creating a url by accessing the document directory in our FileManager
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("myAlarm.json") // <- Change string to app name
        return fileURL
    }
    
    // Save the data at the url
    func saveToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(myAlarms)
            try data.write(to: createFileURL())
        } catch let encodingError {
            print("There was an error encoding the data. \(encodingError.localizedDescription)")
        }
    }
    
    // Fetch the data from the url
    func loadFromPersistentStore() {
        let jsonDecoder = JSONDecoder()
        
        do {
            let decodedData = try Data(contentsOf: createFileURL())
            myAlarms = try jsonDecoder.decode([Alarm].self, from: decodedData)
            // alarms = decodedData
        } catch let decodingError {
            print("There was an error decoding the data. \(decodingError.localizedDescription)")
        }
    }
    
} //End of class

extension AlarmController: AlarmControllerDelegate {
}
