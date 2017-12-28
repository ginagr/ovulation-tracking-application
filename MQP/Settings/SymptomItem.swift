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
    var calendarIcon: String
    var UUID: String
    
    init(name: String, loggingMethod: String, calendarIcon: String, UUID: String) {
        self.name = name
        self.loggingMethod = loggingMethod
        self.calendarIcon = calendarIcon
        self.UUID = UUID
    }
}

