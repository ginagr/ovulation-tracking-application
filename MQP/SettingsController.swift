//
//  SettingsController.swift
//  MQP
//
//  Created by GGR on 12/20/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSettings() {
        //TODO: update settings
        let mainController = storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
        self.present(mainController, animated:false, completion:nil)
    }
    
}
