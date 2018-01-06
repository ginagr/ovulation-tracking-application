//
//  SymptomItem.swift
//  MQP
//
//  Created by GGR on 12/27/17.
//  Copyright © 2017 ggr. All rights reserved.
//
import Foundation

struct SymptomItem {
    
    var name: String
    var loggingMethod: String
    var loggingNames = [String] ()
    var calendarIcons = [String] ()
    var UUID: String
    
    init(name: String, loggingMethod: String, loggingNames: [String], calendarIcons: [String], UUID: String) {
        self.name = name
        self.loggingMethod = loggingMethod
        self.loggingNames = loggingNames
        self.calendarIcons = calendarIcons
        self.UUID = UUID
    }
}

