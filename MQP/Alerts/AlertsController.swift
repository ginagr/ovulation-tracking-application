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
    
    //delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete Reminder Permanently?", message: "", preferredStyle: .alert)
//            let attributedTitle = NSMutableAttributedString(string: "Delete Reminder?")
//            alert.setValue(attributedTitle, forKey: "attributedTitle")
            alert.view.tintColor = PersonalTheme.text  // change text color of the buttons
//            alert.view.backgroundColor = PersonalTheme.secondary  // change background color
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertItem = alertItems[(indexPath as NSIndexPath).row] as AlertItem
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "AddAlertController") as! AddAlertController
        viewController.alert = alertItem
        self.present(viewController, animated:false, completion:nil)
    }
    
}

