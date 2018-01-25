//
//  SymptomsController.swift
//  MQP
//
//  Created by GGR on 12/20/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

class SymptomsController: UIViewController {
    
    @IBOutlet weak var symptomTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme(currView: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSymptoms() {
        //TODO: update symptoms
        let mainController = storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
        self.present(mainController, animated:false, completion:nil)
    }
    
}
