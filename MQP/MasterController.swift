//
//  MasterController.swift
//  MQP
//
//  Created by GGR on 12/21/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import Foundation
import UIKit

struct PersonalTheme {
    static var background = UIColor.white
    static var secondary = UIColor.blue
    static var text = UIColor.black
    
    static func updateBackground(backgroundN: UIColor){
        background = backgroundN
        UserDefaults.standard.setColor(color: backgroundN, forKey: "cBackground")
    }
    static func updateSecondary(secondaryN: UIColor){
        secondary = secondaryN
        UserDefaults.standard.setColor(color: secondaryN, forKey: "cSecondary")
    }
    static func updateText(textN: UIColor){
        text = textN
        UserDefaults.standard.setColor(color: textN, forKey: "cText")
    }
    
    static func loadTheme() {
        let defaults = UserDefaults.standard
        if let cBackground = defaults.colorForKey(key: "cBackground"){
            updateBackground(backgroundN: cBackground)
        }
        if let cSecondary = defaults.colorForKey(key: "cSecondary"){
            updateSecondary(secondaryN: cSecondary)
        }
        if let cText = defaults.colorForKey(key: "cText"){
            updateText(textN: cText)
        }
    }
}

func setupTheme(currView: UIViewController) {
    PersonalTheme.loadTheme()
    currView.view.backgroundColor = PersonalTheme.background
    changeSecondaryColor(currView: currView)
    changeTextColor(currView: currView)
}

func changeTextColor(currView: UIViewController) {
    for view in currView.view.subviews as [UIView] {
        if let btn = view as? UIButton {
//            btn.titleLabel?.textColor = PersonalTheme.text
            btn.setTitleColor(PersonalTheme.text, for: UIControlState.normal)
        } else if let lbl = view as? UILabel {
            lbl.textColor = PersonalTheme.text
        }
    }
}

func changeSecondaryColor(currView: UIViewController) {
    for view in currView.view.subviews as [UIView] {
        if let btn = view as? UIButton {
            if btn.accessibilityHint != "theme" {
                btn.backgroundColor = PersonalTheme.secondary
            }
        } 
    }
}

//defaults.setColor(color: UIColor.red, forKey: "myColor") // set
//let myColor = defaults.colorForKey(key: "myColor") // get
extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
    
}
