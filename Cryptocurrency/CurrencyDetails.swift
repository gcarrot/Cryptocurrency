//
//  CurrencyDetails.swift
//  Cryptocurrency
//
//  Created by Urban Grcar on 12/17/17.
//  Copyright © 2017 Urban Grcar. All rights reserved.
//

import Foundation
import UIKit

class CurrencyDetails: UITableViewController{

    
    var tableTitles = ["Name", "Rank", "Symbol","Price", "24h volume", "Market cap", "Price in bitcon", "1h change", "24h change", "7d change", "Total supply", "Available supply" ]
    var tableValues = [String]()
    
    var currencyID = ""
    var fiatCurrency = "USD"
    var limitSearch = 100
    
    //json URL
    let url_json = "https://api.coinmarketcap.com/v1/ticker/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard;
        limitSearch = userDefaults.integer(forKey: "limit")
        fiatCurrency = userDefaults.string(forKey: "currency")!
        
        getJsonData()
        self.navigationItem.title = "Details"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshData), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        
    }
    
    @objc func refreshData() {
        tableValues = [String]()
        
        getJsonData();
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getJsonData(){
        //print("ID: \(currencyID)")
        let url = URL(string: "\(url_json)\(currencyID)/?convert=\(fiatCurrency)")
        
        // Parse the JSON
        do {
            let contents = try String(contentsOf: url!)
            let data = contents.data(using: String.Encoding.utf8)
            // Attempt to turn it into JSON
            let json = try JSONSerialization.jsonObject(with: data!) as? [[String: Any]]
            
            let fiatCurrencyLower = fiatCurrency.lowercased()
            // Get all elements from data and set to variables
            for element in json! {
                let symbolEl = element["symbol"] as! String
                let nameEl = element["name"] as! String
                let rankEl = element["rank"] as! String
                let priceEl = element["price_\(fiatCurrencyLower)"] as! String
                let changeEl = element["percent_change_24h"] as! String
                let priceBtcEl = element["price_btc"] as! String
                let volume24El = element["24h_volume_usd"] as! String
                let marketCapEl = element["market_cap_usd"] as! String
                let availableEl = element["available_supply"] as! String
                let totalEl = element["total_supply"] as! String
                
                let change1El = element["percent_change_1h"] as! String
                let change24El = element["percent_change_24h"] as! String
                let change7El = element["percent_change_7d"] as! String
                
                tableValues.append(nameEl)
                tableValues.append(rankEl)
                tableValues.append(symbolEl)
                tableValues.append("\(priceEl) \(fiatCurrency)")
                tableValues.append(changeEl)
                tableValues.append(marketCapEl)
                tableValues.append(priceBtcEl)
                tableValues.append(change1El)
                tableValues.append(change24El)
                tableValues.append(change7El)
                tableValues.append(totalEl)
                tableValues.append(availableEl)
            }
            
        } catch {
            print("Error parsing json")
            
        }
    }
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitles.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65.0;//Row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailItemTableView
        
        let title = tableTitles[indexPath.row]
        let value = tableValues[indexPath.row]
        
        cell.titleLabel!.text = title
        cell.valueLabel!.text = value
        return cell
    }
   
    
    
}

