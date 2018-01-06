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
    @IBOutlet weak var nextButton: UIButton!
    
    var loggingButtons = [UIButton] ()
    var loggedMethod = LoggingMethod.binary
    
    var symptom : SymptomItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme(currView: self)
        
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
        case LoggingMethod.binary:
            loggingMethodChosen(binaryButton)
            break
        case LoggingMethod.checklist:
            loggingMethodChosen(checklistButton)
            break
        case LoggingMethod.emoji:
            loggingMethodChosen(emojiButton)
            nextButton.setTitle("SAVE", for: .normal)
            break
        case LoggingMethod.radio:
            loggingMethodChosen(radioButton)
            break
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
       nameTextField.resignFirstResponder()
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
        nextButton.setTitle("NEXT", for: .normal)
        switch sender {
        case binaryButton:
            loggedMethod = LoggingMethod.binary
            break
        case radioButton:
            loggedMethod = LoggingMethod.radio
            break
        case checklistButton:
            loggedMethod = LoggingMethod.checklist
            break
        case emojiButton:
            loggedMethod = LoggingMethod.emoji
             nextButton.setTitle("SAVE", for: .normal)
            break
        default:
            loggedMethod = LoggingMethod.binary
            break
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        let name = nameTextField.text!
        
        if loggedMethod == LoggingMethod.emoji {
            let symptomItem = SymptomItem(name: name, loggingMethod: getLoggingMethodEnum(string: loggedMethod), loggingNames: [], calendarIcons: [], UUID: UUID().uuidString)
            
            if symptom != nil {
                SymptomList.sharedInstance.removeItem(symptom)
                SymptomList.sharedInstance.addItem(symptomItem)
            } else {
                SymptomList.sharedInstance.addItem(symptomItem)
            }
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
            self.present(controller, animated:false, completion:nil)
        } else {
        
            let controller = storyboard?.instantiateViewController(withIdentifier: "AddSymptomLoggingMethodController") as! AddSymptomLoggingMethodController
            controller.name = name
            controller.loggingMethod = loggedMethod
            self.present(controller, animated:false, completion:nil)
        }
    }
}
