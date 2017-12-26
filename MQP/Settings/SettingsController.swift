//
//  SettingsController.swift
//  MQP
//
//  Created by GGR on 12/20/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickerDelegate {
    var selectedColor: UIColor = UIColor.white
    var selectedColorHex: String = "000000"
    var currentColorButton: UIButton!
    
    @IBOutlet weak var backgroundButtonColor: UIButton!
    @IBOutlet weak var secondaryButtonColor: UIButton!
    @IBOutlet weak var textButtonColor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme(currView: self)
        
        updateButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func changeColorButtonClicked(_ sender: UIButton) {
        self.showColorPicker()
        currentColorButton = sender
    }
    
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String) {
        selectedColor = selectedUIColor
        selectedColorHex = selectedHexColor
        
        switch currentColorButton {
        case backgroundButtonColor:
            backgroundButtonColor.backgroundColor = selectedUIColor
            PersonalTheme.updateBackground(backgroundN: selectedUIColor)
            view.backgroundColor = PersonalTheme.background
            break
        case secondaryButtonColor:
            secondaryButtonColor.backgroundColor = selectedUIColor
            PersonalTheme.updateSecondary(secondaryN: selectedUIColor)
            changeSecondaryColor(currView: self)
            break
        case textButtonColor:
            textButtonColor.backgroundColor = selectedUIColor
            PersonalTheme.updateText(textN: selectedUIColor)
            changeTextColor(currView: self)
            break
        default:
            break
        }
    }
    
    private func showColorPicker(){
        let colorPickerVc = storyboard?.instantiateViewController(withIdentifier: "sbColorPicker") as! ColorPickerViewController
        
        colorPickerVc.modalPresentationStyle = .popover

        colorPickerVc.preferredContentSize = CGSize(width: 265, height: 400)
        colorPickerVc.colorPickerDelegate = self
        
        if let popoverController = colorPickerVc.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = backgroundButtonColor.frame
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            popoverController.delegate = self
        }
        present(colorPickerVc, animated: true, completion: nil)
    }
    
    func updateButtons() {
        backgroundButtonColor.backgroundColor = PersonalTheme.background
        secondaryButtonColor.backgroundColor = PersonalTheme.secondary
        textButtonColor.backgroundColor = PersonalTheme.text
        
        backgroundButtonColor.layer.borderWidth = 1
        backgroundButtonColor.layer.borderColor = UIColor.black.cgColor
        secondaryButtonColor.layer.borderWidth = 1
        secondaryButtonColor.layer.borderColor = UIColor.black.cgColor
        textButtonColor.layer.borderWidth = 1
        textButtonColor.layer.borderColor = UIColor.black.cgColor
    }
}
