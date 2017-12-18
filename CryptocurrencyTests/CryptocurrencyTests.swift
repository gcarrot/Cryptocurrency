//
//  CryptocurrencyTests.swift
//  CryptocurrencyTests
//
//  Created by Urban Grcar on 12/18/17.
//  Copyright © 2017 Urban Grcar. All rights reserved.
//

import XCTest
@testable import Cryptocurrency

class CryptocurrencyTests: XCTestCase {
    
    func testCurrenciesLenght() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let collection = CurrencyList()
        let limitSearch = 75
        
        collection.userDefaults.set(limitSearch, forKey: "limit")
        collection.getJsonData()
        
        let lenght = collection.currencies.count
        XCTAssertEqual(lenght, limitSearch)
    }
    
    func testCurrenciesEur() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let collection = CurrencyList()
        let fiatCurrency = "EUR"
        let fiatCurrencyLower = fiatCurrency.lowercased()
        let limitSearch = 1
        
        collection.userDefaults.set(fiatCurrency, forKey: "currency")
        collection.userDefaults.set(limitSearch, forKey: "limit")
        collection.getJsonData()
        
        let lenght = collection.currencies.count
        XCTAssertEqual(lenght, limitSearch)
        
        let currencyEl: Currency
        currencyEl = collection.currencies[0]
        XCTAssertEqual(currencyEl.currency, fiatCurrencyLower)
        
    }
    
    
    
}
