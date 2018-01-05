//
//  AddSymptomController.swift
//  MQP
//
//  Created by GGR on 12/27/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

class AddSymptomController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var binaryButton: UIButton!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var checklistButton: UIButton!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var calendarIconTextField: UITextField!
    
    var loggingButtons = [UIButton] ()
    var loggedMethod = loggingMethod.binary
    
    var symptom : SymptomItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggingButtons.append(binaryButton)
        loggingButtons.append(radioButton)
        loggingButtons.append(checklistButton)
        loggingButtons.append(emojiButton)
        
        if symptom != nil {
            populate()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func populate() {
        nameTextField.text = symptom.name
        let enumlm = getLoggingMethodEnum(enumString: symptom.loggingMethod)
        switch enumlm {
        case loggingMethod.binary:
            loggingMethodChosen(binaryButton)
            break
        case loggingMethod.checklist:
            loggingMethodChosen(checklistButton)
            break
        case loggingMethod.emoji:
            loggingMethodChosen(emojiButton)
            break
        case loggingMethod.radio:
            loggingMethodChosen(radioButton)
            break
        }
        calendarIconTextField.text = symptom.calendarIcon
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        calendarIconTextField.resignFirstResponder()
    }

    @IBAction func loggingTextChosen(_ sender: UIButton) {
        switch sender.currentTitle! {
        case "YES/NO":
            loggingMethodChosen(binaryButton)
            break
        case "RADIO":
            loggingMethodChosen(radioButton)
            break
        case "CHECKLIST":
            loggingMethodChosen(checklistButton)
            break
        case "EMOJI":
            loggingMethodChosen(emojiButton)
            break
        default :
            loggingMethodChosen(binaryButton)
            break
        }
    }
    
    @IBAction func loggingMethodChosen(_ sender: UIButton) {
        loggingButtons.forEach { $0.isSelected = false } // uncheck everything
        sender.isSelected = true // check the button that is clicked on
        switch sender {
        case binaryButton:
            loggedMethod = loggingMethod.binary
            break
        case radioButton:
            loggedMethod = loggingMethod.radio
            break
        case checklistButton:
            loggedMethod = loggingMethod.checklist
            break
        case emojiButton:
            loggedMethod = loggingMethod.emoji
            break
        default:
            loggedMethod = loggingMethod.binary
            break
        }
    }
    
    @IBAction func saveAlert() {
        let name = nameTextField.text!
        let calendarIcon = calendarIconTextField.text!
        
        let symptomItem = SymptomItem(name: name, loggingMethod: getLoggingMethodEnum(string: loggedMethod), calendarIcon: calendarIcon, UUID: UUID().uuidString)
        
        if symptom != nil {
            SymptomList.sharedInstance.removeItem(symptom)
            SymptomList.sharedInstance.addItem(symptomItem)
        } else {
           SymptomList.sharedInstance.addItem(symptomItem)
        }

        let settingsController = storyboard?.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
        self.present(settingsController, animated:false, completion:nil)
    }
}
