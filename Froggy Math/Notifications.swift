//
//  Notifications.swift
//  Froggy Math
//
//  Created by David Chu on 7/27/23.
//

import Foundation
import UserNotifications

class Notifications {
    static let dailyNotificationID = "dailyFrog"
    static let contentTitles = ["It's Froggy Math time!", "Remember to play Froggy Math!", "Your froggies beckon", "You wouldn't ignore your froggies…", "Level up your froggies!", "🐸👅✖️", "Your froggie friends are waiting."]
    static let contentBodies = ["Level up your froggy and get a kiss from David!", "Time for math girl summer!", "Screenshot your froggie when it evolves!", "Don't forget to hone your skillz", "🐸👅✖️", "Frogalicious", "Make David proud but also yourself", "Think how much your froggies miss you!"]
    
    /**
        From here: https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app
        Avoids scheduling another notification if there is already one pending.
     */
    static func registerNewNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                guard request.identifier != dailyNotificationID else {
                    print("Already scheduled notification")
                    return
                }
            }
            
            scheduleNotification()
        })
    }
    
    static func scheduleNotification() {
        // Request notification permission: https://stackoverflow.com/a/42892780/4028758
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { granted, error in
            if granted {
                print("Notifications authorized")
                
                let content = UNMutableNotificationContent()
                content.title = contentTitles.randomElement()!
                content.body = contentBodies.randomElement()!
                
                var dateComponents = DateComponents()
                dateComponents.hour = (10...12).randomElement()! // notify sometime between 10 and 12 am
                dateComponents.minute = (0..<60).randomElement()!
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: dailyNotificationID, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                   if error != nil {
                      // Handle any errors.
                       print("Froggy math notification error: \(error!)")
                   }
                }
            }
        }
    }
}
