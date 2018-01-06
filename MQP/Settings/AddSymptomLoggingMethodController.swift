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
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
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
    var symptom: SymptomItem!
    
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
            numberOptionLabel.isHidden = true
            stepperLabel.isHidden = true
            stepper.isHidden = true
            optionLabel.isHidden = true
            nameLabel.isHidden = true
            iconLabel.isHidden = true
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
        
        if symptom != nil {
            if getLoggingMethodEnum(enumString: symptom.loggingMethod) == .binary {
                calendarIcon.text = symptom.calendarIcons[0]
            } else {
                for index in 0...symptom.loggingNames.count-1 {
                    optionNames[index].text = symptom.loggingNames[index]
                    optionIcons[index].text = symptom.calendarIcons[index]
                    optionNames[index].isHidden = false
                    optionIcons[index].isHidden = false
                    optionLabels[index].isHidden = false
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
    
    @IBAction func stepperAction(_ sender: Any) {
        if (Int(stepperLabel.text!))! < Int(stepper.value) {
            stepperLabel.text = "\(Int(stepper.value))"
            unhideOption()
        } else {
            stepperLabel.text = "\(Int(stepper.value))"
            hideOption()
        }
    }
    
    func unhideOption() {
        optionNames[Int(stepper.value-1)].isHidden = false
        optionIcons[Int(stepper.value-1)].isHidden = false
        optionLabels[Int(stepper.value-1)].isHidden = false
    }
    
    func hideOption() {
        optionNames[Int(stepper.value)].isHidden = true
        optionIcons[Int(stepper.value)].isHidden = true
        optionLabels[Int(stepper.value)].isHidden = true
    }
    
    @IBAction func saveAlert() {
       
        if loggingMethod == .binary {
            let calendarIcons = calendarIcon.text!
            let symptomItem = SymptomItem(name: name, loggingMethod: getLoggingMethodEnum(string: loggingMethod), loggingNames: [], calendarIcons: [calendarIcons], UUID: UUID().uuidString)
            
            if symptom != nil {
                SymptomList.sharedInstance.removeItem(symptom)
                SymptomList.sharedInstance.addItem(symptomItem)
            } else {
                SymptomList.sharedInstance.addItem(symptomItem)
            }
        } else {
            var calendarIcons = [String] ()
            var loggingNames = [String] ()
            for index in 0...Int(stepper.value)-1 {
                calendarIcons.append(optionIcons[index].text!)
                loggingNames.append(optionNames[index].text!)
            }
            let symptomItem = SymptomItem(name: name, loggingMethod: getLoggingMethodEnum(string: loggingMethod), loggingNames: loggingNames, calendarIcons: calendarIcons, UUID: UUID().uuidString)
            
            if symptom != nil {
                SymptomList.sharedInstance.removeItem(symptom)
                SymptomList.sharedInstance.addItem(symptomItem)
            } else {
                SymptomList.sharedInstance.addItem(symptomItem)
            }
        }

        let settingsController = storyboard?.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
        self.present(settingsController, animated:false, completion:nil)
    }
}
