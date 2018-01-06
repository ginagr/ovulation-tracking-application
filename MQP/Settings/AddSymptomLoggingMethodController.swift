//
//  AddSymptomLoggingMethod.swift
//  MQP
//
//  Created by GGR on 1/6/18.
//  Copyright © 2018 ggr. All rights reserved.
//
import UIKit

class AddSymptomLoggingMethodController: UIViewController {
    
    @IBOutlet weak var calendarIconLabel: UILabel!
    @IBOutlet weak var calendarIcon: UITextField!
    @IBOutlet weak var numberOptionLabel: UILabel!
    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var optionOneName: UITextField!
    @IBOutlet weak var optionTwoName: UITextField!
    @IBOutlet weak var optionThreeName: UITextField!
    @IBOutlet weak var optionFourName: UITextField!
    @IBOutlet weak var optionFiveName: UITextField!
    @IBOutlet weak var optionOneIcon: UITextField!
    @IBOutlet weak var optionTwoIcon: UITextField!
    @IBOutlet weak var optionThreeIcon: UITextField!
    @IBOutlet weak var optionFourIcon: UITextField!
    @IBOutlet weak var optionFiveIcon: UITextField!
    @IBOutlet weak var optionOneLabel: UILabel!
    @IBOutlet weak var optionTwoLabel: UILabel!
    @IBOutlet weak var optionThreeLabel: UILabel!
    @IBOutlet weak var optionFourLabel: UILabel!
    @IBOutlet weak var optionFiveLabel: UILabel!
    
    var optionNames = [UITextField] ()
    var optionIcons = [UITextField] ()
    var optionLabels = [UILabel] ()
    
    var name: String!
    var loggingMethod: LoggingMethod!
    
    var fromPrevious = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme(currView: self)
        
        hideAndPopulate()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func hideAndPopulate() {
        optionNames = [optionOneName, optionTwoName, optionThreeName, optionFourName, optionFiveName]
        optionIcons = [optionOneIcon, optionTwoIcon, optionThreeIcon, optionFourIcon, optionFiveIcon]
        optionLabels = [optionOneLabel, optionTwoLabel, optionThreeLabel, optionFourLabel, optionFiveLabel]
        
        if loggingMethod == .binary {
            for index in 0...4 {
                optionNames[index].isHidden = true
                optionIcons[index].isHidden = true
                optionLabels[index].isHidden = true
            }
        } else {
            calendarIcon.isHidden = true
            calendarIconLabel.isHidden = true
            if !fromPrevious {
                for index in 1...4 {
                    optionNames[index].isHidden = true
                    optionIcons[index].isHidden = true
                    optionLabels[index].isHidden = true
                }
            }
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        for index in 0...4 {
            optionIcons[index].resignFirstResponder()
            optionLabels[index].resignFirstResponder()
        }
        calendarIcon.resignFirstResponder()
    }
    
    @IBAction func saveAlert() {
//        let name = symptom.name
//        let calendarIcon = calendarIconTextField.text!
        
//        let symptomItem = SymptomItem(name: name, loggingMethod: symptom.loggingMethod, loggingNames: calendarIcon: calendarIcons, UUID: UUID().uuidString)
        
//        if symptom != nil {
//            SymptomList.sharedInstance.removeItem(symptom)
//            SymptomList.sharedInstance.addItem(symptomItem)
//        } else {
//            SymptomList.sharedInstance.addItem(symptomItem)
//        }
//
        let settingsController = storyboard?.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
        self.present(settingsController, animated:false, completion:nil)
    }
}
