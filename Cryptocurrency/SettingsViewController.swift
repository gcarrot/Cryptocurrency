//
//  SettingsViewController.swift
//  Cryptocurrency
//
//  Created by Urban Grcar on 12/17/17.
//  Copyright © 2017 Urban Grcar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var limitTF: UITextField!
    @IBOutlet weak var usdBtn: UIButton!
    @IBOutlet weak var eurBtn: UIButton!
    @IBOutlet weak var cnyBtn: UIButton!
    
    let userDefaults = UserDefaults.standard;
    
    var limitSearch = 100
    var fiatCurrency = "USD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view, typically from a nib.
        
        limitSearch = userDefaults.integer(forKey: "limit")
        fiatCurrency = userDefaults.string(forKey: "currency")!
        
        self.navigationItem.title = "Settings"
        
        if(fiatCurrency == "CNY"){
            cnyBtn.backgroundColor = UIColor.blue
            cnyBtn.tintColor = UIColor.white
        } else if(fiatCurrency == "EUR"){
            eurBtn.backgroundColor = UIColor.blue
            eurBtn.tintColor = UIColor.white
        } else {
            usdBtn.backgroundColor = UIColor.blue
            usdBtn.tintColor = UIColor.white
        }
        limitTF.text = String(limitSearch)
        limitTF.addTarget(self, action: #selector(changeLimit), for: .editingChanged)
        
        usdBtn.tag = 1
        usdBtn.addTarget(self, action: #selector(changeCurrency(sender:)), for: UIControlEvents.touchUpInside)
        
        eurBtn.tag = 2
        eurBtn.addTarget(self, action: #selector(changeCurrency(sender:)), for: UIControlEvents.touchUpInside)
        
        cnyBtn.tag = 3
        cnyBtn.addTarget(self, action: #selector(changeCurrency(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func changeLimit() {
        let limit = Int(limitTF.text!)
        //print("Limit \(limit)")
        userDefaults.set(limit, forKey: "limit")
        userDefaults.synchronize()
    }
    
    @objc func changeCurrency(sender: UIButton) {
        var currencySelected = ""
        switch sender.tag {
        case 1:
            usdBtn.backgroundColor = UIColor.blue
            usdBtn.tintColor = UIColor.white
            
            eurBtn.backgroundColor = UIColor.white
            eurBtn.tintColor = UIColor.blue
            cnyBtn.backgroundColor = UIColor.white
            cnyBtn.tintColor = UIColor.blue
            currencySelected = "USD"
            break
        case 2:
            eurBtn.backgroundColor = UIColor.blue
            eurBtn.tintColor = UIColor.white
            
            usdBtn.backgroundColor = UIColor.white
            usdBtn.tintColor = UIColor.blue
            cnyBtn.backgroundColor = UIColor.white
            cnyBtn.tintColor = UIColor.blue
            currencySelected = "EUR"
            break
        case 3:
            cnyBtn.backgroundColor = UIColor.blue
            cnyBtn.tintColor = UIColor.white
            
            usdBtn.backgroundColor = UIColor.white
            usdBtn.tintColor = UIColor.blue
            eurBtn.backgroundColor = UIColor.white
            eurBtn.tintColor = UIColor.blue
            currencySelected = "CNY"
            break
        default: currencySelected = "USD"
        }
        
        userDefaults.set(currencySelected, forKey: "currency")
        userDefaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
