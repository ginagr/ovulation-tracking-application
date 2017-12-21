//
//  SettingsController.swift
//  MQP
//
//  Created by GGR on 12/20/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickerDelegate {
    
    // class varible maintain selected color value
    var selectedColor: UIColor = UIColor.white
    var selectedColorHex: String = "000000"
    var currentColorButton: UIButton!
    
    @IBOutlet weak var backgroundButtonColor: UIButton!
    @IBOutlet weak var secondaryButtonColor: UIButton!
    @IBOutlet weak var textButtonColor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PersonalTheme.background
        backgroundButtonColor.backgroundColor = PersonalTheme.background
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Override iPhone behavior that presents a popover as fullscreen.
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none // show popover box for iPhone and iPad both
    }
    
    @IBAction func changeColorButtonClicked(_ sender: UIButton) {
        self.showColorPicker() // action - called when change color button clicked
        currentColorButton = sender
    }
    
    // called by color picker after color selected.
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String) {
        selectedColor = selectedUIColor
        selectedColorHex = selectedHexColor
        
        switch currentColorButton {
        case backgroundButtonColor:
            backgroundButtonColor.backgroundColor = selectedUIColor
            PersonalTheme.background = selectedUIColor
            view.backgroundColor = PersonalTheme.background
            break
        case secondaryButtonColor:
            secondaryButtonColor.backgroundColor = selectedUIColor
            break
        case textButtonColor:
            textButtonColor.backgroundColor = selectedUIColor
            break
        default:
            break
        }
    }
    
    // show color picker from UIButton
    private func showColorPicker(){
        
        // initialise color picker view controller
        let colorPickerVc = storyboard?.instantiateViewController(withIdentifier: "sbColorPicker") as! ColorPickerViewController
        
        // set modal presentation style
        colorPickerVc.modalPresentationStyle = .popover
        
        // set max. size
        colorPickerVc.preferredContentSize = CGSize(width: 265, height: 400)
        
        // set color picker deleagate to current view controller
        // must write delegate method to handle selected color
        colorPickerVc.colorPickerDelegate = self
        
        // show popover
        if let popoverController = colorPickerVc.popoverPresentationController {
            
            // set source view
            popoverController.sourceView = self.view
            
            // show popover form button
//            popoverController.sourceRect = self.changeColorButton.frame
            popoverController.sourceRect = backgroundButtonColor.frame
            
            // show popover arrow at feasible direction
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            
            // set popover delegate self
            popoverController.delegate = self
        }
        
        //show color popover
        present(colorPickerVc, animated: true, completion: nil)
    }
    
    @IBAction func saveSettings() {
        //TODO: update settings
        let mainController = storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
        self.present(mainController, animated:false, completion:nil)
    }
    
    
    
}
