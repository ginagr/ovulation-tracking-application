//
//  DayItem.swift
//  MQP
//
//  Created by GGR on 1/7/18.
//  Copyright © 2018 ggr. All rights reserved.
//

import Foundation

struct DayItem {
    
    var date: Date
    var symptoms = [SymptomItem] ()
    var notes: String
    var logged: Bool
    var UUID: String
    
    init(date: Date, symptoms: [SymptomItem], notes: String, logged: Bool, UUID: String) {
        self.date = date
        self.symptoms = symptoms
        self.notes = notes
        self.logged = logged
        self.UUID = UUID
    }
}


