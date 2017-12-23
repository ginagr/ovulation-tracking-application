//
//  AddAlertController.swift
//  MQP
//
//  Created by GGR on 12/22/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

class AddAlertController: UIViewController {
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var occurrenceStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var alerts:[UIStackView]!
    
    var occurrences: [UIDatePicker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme(currView: self)
        
        scrollView.isScrollEnabled = true
        scrollView.contentSize.height = occurrenceStackView.frame.height + 30
        
        for index in 0...Int(stepperValue.text!)!-1 {
            alerts[index].isHidden = false
        }
        for index in Int(stepperValue.text!)!...9 {
            alerts[index].isHidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        alerts[Int(stepperValue.text!)!-1].isHidden = false
        
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
    
    func occurrenceTimeChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: sender.date)
        print("Time: \(time) &&  \(String(describing: occurrences.index(of: sender)))")
        
    }
    
    func deleteOccurence() {
         alerts[Int(stepperValue.text!)!-1].isHidden = true
    }
}

