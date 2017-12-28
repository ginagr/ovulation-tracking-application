//
//  AlertItem.swift
//  MQP
//
//  Created by GGR on 12/24/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import Foundation

struct AlertItem {
    
    var name: String
    var title: String
    var body: String
    var everyday: Bool
    var weekdays = [Bool] () //sun-mon
    var times = [Date] ()
    var UUID: String

    init(name: String, title: String, body: String, everyday: Bool, weekdays: [Bool], times: [Date], UUID: String) {
        self.name = name
        self.title = title
        self.body = body
        self.everyday = everyday
        self.weekdays = weekdays
        self.times = times
        self.UUID = UUID
    }

    var isOverdue: Bool {
        let date = Date()
        let calendar = Calendar.current
        let currHour = calendar.component(.hour, from: date)
        let currMin = calendar.component(.minute, from: date)
        let currDay = calendar.component(.weekday, from: date)
        
        if everyday || weekdays[currDay-1] {
            for (_,element) in times.enumerated() {
                let hour = calendar.component(.hour, from: element)
                let min = calendar.component(.hour, from: element)
                if hour == currHour && min == currMin {
                    return true
                }
            }
        }
        return false
    }
}
