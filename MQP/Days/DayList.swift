//
//  DayList.swift
//  MQP
//
//  Created by GGR on 1/7/18.
//  Copyright © 2018 ggr. All rights reserved.
//

import UIKit


class DayList {
    class var sharedInstance : DayList {
        struct Static {
            static let instance: DayList = DayList()
        }
        return Static.instance
    }

    fileprivate let ITEMS_KEY = "dayItems"
    
    func allItems() -> [DayItem] {
        let dayDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(dayDictionary.values)
        return items.map({
            let item = $0 as! [String:AnyObject]
            return DayItem(date: item["date"] as! Date, symptoms: item["symptoms"] as! [SymptomItem], notes: item["notes"] as! String, logged: item["logged"] as! Bool, UUID: item["UUID"] as! String!)
        }).sorted(by: {(left: DayItem, right:DayItem) -> Bool in
            (left.date.compare(right.date) == .orderedAscending)
        })
    }
    
    func addItem(_ item: DayItem) {
        // persist a representation of this day item in NSUserDefaults
        var dayDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()
        dayDictionary[item.UUID] = ["date": item.date, "symptoms": item.symptoms, "notes": item.notes, "logged": item.logged, "UUID": item.UUID]
        UserDefaults.standard.set(dayDictionary, forKey: ITEMS_KEY)
    }
    
    func removeItem(_ item: DayItem) {
        if var dayItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
            dayItems.removeValue(forKey: item.UUID)
            UserDefaults.standard.set(dayItems, forKey: ITEMS_KEY) // save/overwrite symptom item list
        }
    }
}

