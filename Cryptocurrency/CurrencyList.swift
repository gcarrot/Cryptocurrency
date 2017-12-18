//
//  CurrencyList.swift
//  Cryptocurrency
//
//  Created by Urban Grcar on 12/17/17.
//  Copyright © 2017 Urban Grcar. All rights reserved.
//

import Foundation
import UIKit

class CurrencyList: UITableViewController {

    @IBOutlet var tableList: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var currencies = [Currency]()
    var filteredData = [Currency]()
    
    var fiatCurrency = "USD"
    var limitSearch = 100
    let userDefaults = UserDefaults.standard;
    
    //json URL
    let url_json = "https://api.coinmarketcap.com/v1/ticker/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Currencies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshData), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        
        getJsonData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getJsonData();
        tableView.reloadData()
    }
    
    @objc func refreshData() {
        getJsonData();
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Table View setup
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredData.count
        }
        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75.0;//Row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell

        let currency: Currency
        if isFiltering() {
            currency = filteredData[indexPath.row]
        } else {
            currency = currencies[indexPath.row]
        }

        cell.rankLabel.text = "#"+String(currency.rank)
        cell.symoblLabel.text = currency.symbol
        cell.change24Label.text = currency.change24
        cell.priceLabel.text = "\(String(currency.price)) \(fiatCurrency)"
        
        return cell
    }
    
    
    public func getJsonData(){
        currencies = [Currency]()
        filteredData = [Currency]()
        
        limitSearch = userDefaults.integer(forKey: "limit")
        fiatCurrency = userDefaults.string(forKey: "currency")!
        
        // Set view nav title
        let title = "Top \(String(limitSearch)) Cryptocurrencies " //- \(fiatCurrency)
        self.navigationItem.title = title
        
        let url = URL(string: "\(url_json)?convert=\(fiatCurrency)&limit=\(limitSearch)")
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
                let idEl = element["id"] as! String
                let currencyEl = "\(fiatCurrencyLower)"
                
                let c = Currency(rank: Int(rankEl)!, symbol: symbolEl, change24: changeEl, price: Double(priceEl)!, name: nameEl, id: idEl, currency: currencyEl)
                currencies.append(c)
            }
            
        } catch {
            print("Error parsing json")

        }
    }
    
    func filterContent(_ searchText: String) {
        filteredData = currencies.filter({( currency : Currency) -> Bool in
            // Return values where name or symbol contains search text
            return currency.symbol.lowercased().contains(searchText.lowercased()) || currency.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive
    }
    
    
    // Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let currency: Currency
                if isFiltering() {
                    currency = filteredData[indexPath.row]
                } else {
                    currency = currencies[indexPath.row]
                }
                let controller = segue.destination as? CurrencyDetails
                controller?.currencyID = currency.id
            }
        }
    }
}



extension CurrencyList: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar) {
        filterContent(searchBar.text!)
    }
}

extension CurrencyList: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContent(searchController.searchBar.text!)
    }
}
