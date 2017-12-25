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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("TABLEVIEW4")
        if editingStyle == .delete { // the only editing style we'll support
            // Delete the row from the data source
            let item = alertItems.remove(at: (indexPath as NSIndexPath).row) // remove TodoItem from notifications array, assign removed item to 'item'
            alertTable.deleteRows(at: [indexPath], with: .fade)
            AlertList.sharedInstance.removeItem(item) // delete backing property list entry and unschedule local notification (if it still exists)
        }
    }
    
    @IBAction func deleteAlert(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let attributedTitle = NSMutableAttributedString(string: "Delete Reminder?")
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        
        let action = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
            print("Deleting reminder")
//            let item = alertItems.remove(at: (indexPath as NSIndexPath).row) // remove TodoItem from notifications array, assign removed item to 'item'
//            alertTable.deleteRows(at: [indexPath], with: .fade)
//            AlertList.sharedInstance.removeItem(item) // delete backing property list entry and unschedule local notification (if it still exists)
        })
        
        alert.view.tintColor = PersonalTheme.text  // change text color of the buttons
        alert.view.backgroundColor = PersonalTheme.secondary  // change background color
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editAlert(_ sender: UIButton) {
        let mainController = storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
        self.present(mainController, animated:false, completion:nil)
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
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) // retrieve the prototype cell (subtitle style)
        let alertItem = alertItems[(indexPath as NSIndexPath).row] as AlertItem
        
        cell.textLabel?.text = "Name: " + alertItem.name as String!
        cell.detailTextLabel?.textColor = PersonalTheme.text
        cell.detailTextLabel?.text = "Title: " + alertItem.title as String!
        return cell
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // all cells are editable
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertItem = alertItems[(indexPath as NSIndexPath).row] as AlertItem
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AddAlertController") as! AddAlertController
        viewController.alert = alertItem
        self.present(viewController, animated:false, completion:nil)
    }
    
}

