//
//  SymptomList.swift
//  MQP
//
//  Created by GGR on 12/27/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit


class SymptomList {
    class var sharedInstance : SymptomList {
        struct Static {
            static let instance: SymptomList = SymptomList()
        }
        return Static.instance
    }
    
    fileprivate let ITEMS_KEY = "symptomItems"
    
    func allItems() -> [SymptomItem] {
        let symptomDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(symptomDictionary.values)
        return items.map({
            let item = $0 as! [String:AnyObject]
            return SymptomItem(name: item["name"] as! String, loggingMethod: item["loggingMethod"] as! String, calendarIcon: item["calendarIcon"] as! String, UUID: item["UUID"] as! String!)
        }).sorted(by: {(left: SymptomItem, right:SymptomItem) -> Bool in
            (left.name.compare(right.name) == .orderedAscending)
        })
    }
    
    func addItem(_ item: SymptomItem) {
        // persist a representation of this symptom item in NSUserDefaults
        var symptomDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()
        symptomDictionary[item.UUID] = ["name": item.name, "loggingMethod": item.loggingMethod, "calendarIcon": item.calendarIcon, "UUID": item.UUID]
        UserDefaults.standard.set(symptomDictionary, forKey: ITEMS_KEY)
    }
    
    func removeItem(_ item: SymptomItem) {
        if var symptomItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
            symptomItems.removeValue(forKey: item.UUID)
            UserDefaults.standard.set(symptomItems, forKey: ITEMS_KEY) // save/overwrite symptom item list
        }
    }
}
