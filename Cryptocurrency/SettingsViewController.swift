//
//  SettingsViewController.swift
//  Cryptocurrency
//
//  Created by Urban Grcar on 12/17/17.
//  Copyright © 2017 Urban Grcar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard;
        let limitSearch = 50
        let fiatCurrency = "EUR"
        userDefaults.set(limitSearch, forKey: "limit")
        userDefaults.set(fiatCurrency, forKey: "currency")

    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
