//
//  AddAlertController.swift
//  MQP
//
//  Created by GGR on 12/22/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

class AddAlertController: UIViewController {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyField: UITextField!
    
    @IBOutlet weak var weekStackView: UIStackView!
    @IBOutlet weak var dailySwitch: UISwitch!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var alarmOne: UIStackView!
    @IBOutlet weak var alarmTwo: UIStackView!
    @IBOutlet weak var alarmThree: UIStackView!
    @IBOutlet weak var alarmFour: UIStackView!
    @IBOutlet weak var alarmFive: UIStackView!
    
    var alerts = [UIStackView] ()
    var lastEdited: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme(currView: self)
        dailySwitch.isOn = false
        
//        scrollView.isScrollEnabled = true
//        scrollView.contentSize.height = UIScreen.main.bounds.height
        
        alerts = [alarmOne, alarmTwo, alarmThree, alarmFour, alarmFive]
        alerts.append(alarmOne)
        alerts.append(alarmTwo)
        alerts.append(alarmThree)
        alerts.append(alarmFour)
        alerts.append(alarmFive)

        for index in 0...Int(stepper.value-1) {
            alerts[index].isHidden = false
        }
        for index in Int(stepper.value-1)...4 {
            alerts[index].isHidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stepperAction(_ sender: Any) {
        if (Int(stepperValue.text!))! < Int(stepper.value) {
            stepperValue.text = "\(Int(stepper.value))"
            addOccurence()
        } else {
            stepperValue.text = "\(Int(stepper.value))"
            deleteOccurence()
        }
    }
    
    func addOccurence() {
        let occurence = Int(stepperValue.text!)!-1
        alerts[occurence].isHidden = false
        
//        for case let textField as UITextField in alerts[occurence].subviews {
//            print("adding target for \(String(describing: textField.text))")
//            textField.addTarget(self, action: Selector(("timePickerChanged:")), for: .valueChanged)
//        }
        
        
//        let verticalView = UIStackView()
//        verticalView.axis = .horizontal
//        verticalView.spacing = 5
//
//        let label = UILabel()
//        label.text = "Alert Time #\(occurrences.count+1)"
//        let label1 = UILabel()
//        label1.text = "12:00"
//
//        let timePicker = UIDatePicker()
//        timePicker.datePickerMode = UIDatePickerMode.time
//        timePicker.addTarget(self, action: Selector(("occurrenceTimeChanged:")), for: .valueChanged)
//        occurrences.append(timePicker)
//
//        verticalView.addSubview(label)
////        verticalView.addSubview(label1)
//        let widthCst = NSLayoutConstraint(item: verticalView, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: occurrenceStackView.frame.width)
//        let heightCst = NSLayoutConstraint(item: verticalView, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
//        verticalView.addConstraint(widthCst)
//        verticalView.addConstraint(heightCst)
//
//        occurrenceStackView.addArrangedSubview(verticalView)

    }
    
    @IBAction func timePickerChanged(_ sender: UITextField) {
        lastEdited = sender
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePickerView.datePickerMode = UIDatePickerMode.time
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: #selector(doneButton(sender:)), for: UIControlEvents.touchUpInside) // set button click event
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControlEvents.valueChanged)
    }
    
    @objc func doneButton(sender:UIButton) {
        view.endEditing(true)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        lastEdited.text = dateFormatter.string(from: sender.date)
    }

    func deleteOccurence() {
         alerts[Int(stepperValue.text!)!].isHidden = true
    }
    
    @IBAction func weekButtonTouched(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
             sender.isSelected = true
        }
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            for case let button as UIButton in weekStackView.subviews {
                button.isSelected = true
                button.isEnabled = false
            }
        } else {
            for case let button as UIButton in weekStackView.subviews {
                button.isSelected = false
                button.isEnabled = true
            }
        }
    }
    
    @IBAction func saveAlert() {
        let name = nameField.text!
        let title = titleField.text!
        let body = bodyField.text!
        let everyday = dailySwitch.isOn
        let weekdays = [mondayButton.isSelected, tuesdayButton.isSelected, wednesdayButton.isSelected, thursdayButton.isSelected, fridayButton.isSelected, saturdayButton.isSelected, sundayButton.isSelected]
        var times = [Date] ()
        for index in 0...Int(stepper.value-1) {
            for case let textField as UITextField in alerts[index].subviews {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                let date = dateFormatter.date(from: textField.text!)
                times.append(date!)
            }
        }
        
        let alertItem = AlertItem(name: name, title: title, body: body, everyday: everyday, weekdays: weekdays, times: times, UUID: UUID().uuidString)
        
        AlertList.sharedInstance.addItem(alertItem) // schedule a local notification to persist this item
        
        let mainController = storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
        self.present(mainController, animated:false, completion:nil)
        
    }
}

