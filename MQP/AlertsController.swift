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
        
//        center.getNotificationSettings { (settings) in
//            if settings.authorizationStatus != .authorized {
//                // Notifications not allowed
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

