//
//  SettingsVC.swift
//  GST Calculator
//
//  Created by Andrew Foster on 7/11/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit
import StoreKit

class SettingsVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestProducts()
    }
    
    // Request products from Apple
    func requestProducts() {
        let IDs : Set<String> = ["com.andriiHalabuda.GSTCalculator.ad"]
        let productsRequest = SKProductsRequest(productIdentifiers: IDs)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // Handling Apple response
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Products ready: \(response.products.count)")
        print("Products not ready: \(response.invalidProductIdentifiers.count)")
        self.products = response.products
    }
    
    // Restore previous purchases
    @IBAction func restoreBtnTapped(_ sender: Any) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // Creating payment queue
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased:
                print("Purchased")
                unlockArt(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                print("Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                print("Restored")
                unlockArt(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .purchasing:
                print("Purchasing")
                break
            case .deferred:
                print("Deffered")
                break
            }
        }
    }
    
    // Show an art when purchased or restored
    func unlockArt(_ productIdentifier:String) {
        
        
    }
    
}
