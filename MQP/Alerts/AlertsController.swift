//
//  AlertsController.swift
//  MQP
//
//  Created by GGR on 12/20/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit
import UserNotifications

class AlertsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var alertTable: UITableView!
    
    var alertItems: [AlertItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme(currView: self)
        
        alertTable.delegate = self
        alertTable.dataSource = self
        
        alertTable.backgroundColor = PersonalTheme.background
        alertTable.separatorColor = PersonalTheme.secondary
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name: NSNotification.Name(rawValue: "AlertListShouldRefresh"), object: nil)
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                print("NOTIFICATIONS NOT ALLOWED")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    @objc func refreshList() {
        alertItems = AlertList.sharedInstance.allItems()
        alertTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertItems.count
    }
    
    //populate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath)
        let alertItem = alertItems[(indexPath as NSIndexPath).row] as AlertItem
        
        if alertItem.name.count > 1 {
            cell.textLabel?.text = alertItem.name as String!
            cell.detailTextLabel?.text = alertItem.title as String!
        } else { //no name
            cell.textLabel?.text = alertItem.title as String!
        }
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
        let alertItem = alertItems[(indexPath as NSIndexPath).row] as AlertItem
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AddAlertController") as! AddAlertController
        viewController.alert = alertItem
        self.present(viewController, animated:false, completion:nil)
    }
    
    //delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("EDITING STYLE: \(editingStyle)")
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete Reminder Permanently?", message: "", preferredStyle: .alert)
            alert.view.tintColor = PersonalTheme.text  // change text color of the buttons
            
            let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                print("Deleting reminder")
                let item = self.alertItems.remove(at: (indexPath as NSIndexPath).row)
                self.alertTable.deleteRows(at: [indexPath], with: .fade)
                AlertList.sharedInstance.removeItem(item)
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
            let alert = UIAlertController(title: "Delete Reminder Permanently?", message: "", preferredStyle: .alert)
            alert.view.tintColor = PersonalTheme.text  // change text color of the buttons
            
            let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                print("Deleting reminder")
                let item = self.alertItems.remove(at: (indexPath as NSIndexPath).row)
                self.alertTable.deleteRows(at: [indexPath], with: .fade)
                AlertList.sharedInstance.removeItem(item)
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

