//
//  AlertList.swift
//  MQP
//
//  Created by GGR on 12/24/17.
//  Copyright © 2017 ggr. All rights reserved.
//
import UIKit
import UserNotifications

class AlertList {
    class var sharedInstance : AlertList {
        struct Static {
            static let instance: AlertList = AlertList()
        }
        return Static.instance
    }
    
    fileprivate let ITEMS_KEY = "alertItems"
    
    func allItems() -> [AlertItem] {
        let alertDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(alertDictionary.values)
        return items.map({
            let item = $0 as! [String:AnyObject]
            return AlertItem(name: item["name"] as! String, title: item["title"] as! String, body: item["body"] as! String,
                             everyday: item["everyday"] as! Bool, weekdays: item["weekdays"] as! [Bool], times: item["times"] as! [Date], UUID: item["UUID"] as! String!)
        }).sorted(by: {(left: AlertItem, right:AlertItem) -> Bool in
            (left.name.compare(right.name) == .orderedAscending)
        })
    }
    
    func addItem(_ item: AlertItem) {
        // persist a representation of this alert item in NSUserDefaults
        var alertDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        alertDictionary[item.UUID] = ["name": item.name, "title": item.title, "body": item.body, "everyday": item.everyday,
                                      "weekdays": item.weekdays, "times": item.times, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        UserDefaults.standard.set(alertDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UNMutableNotificationContent()
        notification.title = item.title
        notification.body = item.body
        notification.sound = UNNotificationSound.default()
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        if item.everyday {
            for(_,element) in item.times.enumerated() {
                let triggerDate =  Calendar.current.dateComponents([.hour,.minute], from: element as Date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
//                let identifier = item.UUID + "_" + String(index)
                let identifier = item.UUID
                let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: { (error) in
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: element)
                    let minutes = calendar.component(.minute, from: element)
                    if error != nil  {
                        print("ERROR WITH NOTIFICATIONS: \(error!)")
                        print("Reminder \(item.name) has NOT been added successfully added with hour: \(hour), minute: \(minutes)")
                    } else {
                        print("Reminder \(item.name) has been added successfully added with hour: \(hour), minute: \(minutes)")
                    }
                })
            }
        } else {
            for(index,element) in item.weekdays.enumerated() {
                if element {
                    for(_,time) in item.times.enumerated() {
                        let date = createDate(weekday: index+1, date: time)
                        let triggerDate =  Calendar.current.dateComponents([.weekday,.hour,.minute], from: date as Date)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
//                        let identifier = item.UUID + "_" + String(index)
                        let identifier = item.UUID
                        let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
                        let center = UNUserNotificationCenter.current()
                        center.add(request, withCompletionHandler: { (error) in
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            let minutes = calendar.component(.minute, from: date)
                            let weekday = calendar.component(.weekday, from: date)
                            if error != nil  {
                                print("ERROR WITH NOTIFICATIONS: \(error!)")
                                print("Reminder \(item.name) has NOT been added successfully added with weekday: \(weekday),hour: \(hour), minute: \(minutes)")
                            } else {
                                print("Reminder \(item.name) has been added successfully added with weekday: \(weekday),hour: \(hour), minute: \(minutes)")
                            }
                        })
                    }
                }
            }
        }
    }
    
    func createDate(weekday: Int, date: Date)-> Date {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)

        var components = DateComponents()
        components.hour = hour
        components.minute = minutes
        components.year = 2000
        components.weekday = weekday // sunday = 1 ... saturday = 7
        components.weekdayOrdinal = 10
        components.timeZone = .current
        
        let calendar1 = Calendar(identifier: .gregorian)
        return calendar1.date(from: components)!
    }

    
    func removeItem(_ item: AlertItem) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [item.UUID])
//        center.getPendingNotificationRequests(completionHandler: { (notifications) in
//            print("notifications.count", notifications.count)
//            for notification in notifications {
//                if (notification.identifier == item.UUID) {
//
////                    UIApplication.shared.cancelLocalNotification(notification)
//                }
//            }
//        })
        
        if var alertItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
            alertItems.removeValue(forKey: item.UUID)
            UserDefaults.standard.set(alertItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
    }
}
