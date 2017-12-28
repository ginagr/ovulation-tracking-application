//
//  SettingsController.swift
//  MQP
//
//  Created by GGR on 12/20/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var selectedColor: UIColor = UIColor.white
    var selectedColorHex: String = "000000"
    var currentColorButton: UIButton!
    
    @IBOutlet weak var backgroundButtonColor: UIButton!
    @IBOutlet weak var secondaryButtonColor: UIButton!
    @IBOutlet weak var textButtonColor: UIButton!
    @IBOutlet weak var symptomsTable: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var symptomItems: [SymptomItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme(currView: self)
        updateButtons()
        
        scrollView.isScrollEnabled = true
        scrollView.contentSize.height = UIScreen.main.bounds.height
        
        symptomsTable.delegate = self
        symptomsTable.dataSource = self
        
        symptomsTable.backgroundColor = PersonalTheme.background
        symptomsTable.separatorColor = PersonalTheme.secondary
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    @objc func refreshList() {
        symptomItems = SymptomList.sharedInstance.allItems()
        symptomsTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptomItems.count
    }
    
    //populate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "symptomCell", for: indexPath)
        let symptomItem = symptomItems[(indexPath as NSIndexPath).row] as SymptomItem
        
       
        cell.textLabel?.text = symptomItem.name as String!
    
        cell.textLabel?.textColor = PersonalTheme.text
        cell.detailTextLabel?.textColor = PersonalTheme.text
        cell.backgroundColor = PersonalTheme.background
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // all cells are editable
    }
    
    //edit
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let symptomItem = symptomItems[(indexPath as NSIndexPath).row] as SymptomItem
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AddSymptomController") as! AddSymptomController
        viewController.symptom = symptomItem
        self.present(viewController, animated:false, completion:nil)
    }
    
    //delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("EDITING STYLE: \(editingStyle)")
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete Symptom Permanently?", message: "", preferredStyle: .alert)
            alert.view.tintColor = PersonalTheme.text  // change text color of the buttons
            
            let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                print("Deleting symptom")
                let item = self.symptomItems.remove(at: (indexPath as NSIndexPath).row)
                self.symptomsTable.deleteRows(at: [indexPath], with: .fade)
                SymptomList.sharedInstance.removeItem(item)
            })
            
            alert.addAction(action)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //deactivate and delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //deactivate  TODO: fix
        //        let editAction = UITableViewRowAction(style: .default, title: "Deactivate", handler: { (action, indexPath) in
        //            print("Deactivating reminder")
        //            let alertItem = self.alertItems[(indexPath as NSIndexPath).row] as AlertItem
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath)
        //            cell.backgroundColor = UIColor.lightGray
        //        })
        //        editAction.backgroundColor = UIColor.blue
        
        //delete
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "Delete Symptom Permanently?", message: "", preferredStyle: .alert)
            alert.view.tintColor = PersonalTheme.text  // change text color of the buttons
            
            let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                print("Deleting symptom")
                let item = self.symptomItems.remove(at: (indexPath as NSIndexPath).row)
                self.symptomsTable.deleteRows(at: [indexPath], with: .fade)
                SymptomList.sharedInstance.removeItem(item)
            })
            
            alert.addAction(action)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
        deleteAction.backgroundColor = UIColor.red
        
        //  return [editAction, deleteAction]
        return [deleteAction]
    }
    
}
