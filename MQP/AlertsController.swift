//
//  AlertsController.swift
//  MQP
//
//  Created by GGR on 12/20/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit
import UserNotifications

class AlertsController: UIViewController {
    
    @IBOutlet weak var alertTable: UITableView!
    
    var alertItems: [AlertItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme(currView: self)
        
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
    
    @IBAction func deleteAlert(_ sender: UIButton) {
    }
    @IBAction func editAlert(_ sender: UIButton) {
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
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertItems.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) // retrieve the prototype cell (subtitle style)
        let alertItem = alertItems[(indexPath as NSIndexPath).row] as AlertItem
        
        cell.textLabel?.text = alertItem.name as String!
//        if (alertItem.isOverdue) { // the current time is later than the to-do item's deadline
//            cell.detailTextLabel?.textColor = UIColor.red
//        } else {
            cell.detailTextLabel?.textColor = PersonalTheme.text // we need to reset this because a cell with red subtitle may be returned by dequeueReusableCellWithIdentifier:indexPath:
//        }
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a" // example: "Due Jan 01 at 12:00 PM"
//        cell.detailTextLabel?.text = dateFormatter.string(from: todoItem.deadline as Date)
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // all cells are editable
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { // the only editing style we'll support
            // Delete the row from the data source
            let item = alertItems.remove(at: (indexPath as NSIndexPath).row) // remove TodoItem from notifications array, assign removed item to 'item'
            alertTable.deleteRows(at: [indexPath], with: .fade)
            AlertList.sharedInstance.removeItem(item) // delete backing property list entry and unschedule local notification (if it still exists)
        }
    }
    
    
}

