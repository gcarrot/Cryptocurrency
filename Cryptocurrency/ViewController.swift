//
//  ViewController.swift
//  Cryptocurrency
//
//  Created by Urban Grcar on 12/14/17.
//  Copyright © 2017 Urban Grcar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var topLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard;
        var limitSearch = 100
        var fiatCurrency = "USD"
        
        if userDefaults.bool(forKey: "limit") == true {
            limitSearch = userDefaults.integer(forKey: "limit")
        } else {
            userDefaults.set(limitSearch, forKey: "limit")
        }
        
        
        if userDefaults.bool(forKey: "currency") == true {
            fiatCurrency = userDefaults.string(forKey: "currency")!
        } else {
            userDefaults.set(fiatCurrency, forKey: "currency")
        }
        
        
        
        topLabel.text = "Top " + String(limitSearch) + " Cryptocurrencies" + " - " + fiatCurrency
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

