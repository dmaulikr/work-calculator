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
    
    let AD_FREE_ID = "com.andriiHalabuda.GSTCalculator.ad"
    var products = [SKProduct]()
    var productID = ""
    let appUrl = URL(string: "itms-apps://itunes.apple.com/app/id1178333093") //<- Change!!!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Purchased:", adFreePurchaseMade)
        
        if adFreePurchaseMade {
            // Close Ad
        } else {
            // Show Ad
        }
        
        requestProducts()
    }
    
    // Request products from Apple
    func requestProducts() {
        let productIdentifiers : Set<String> = [AD_FREE_ID]
        let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
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
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // Creating payment queue
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased:
                print("Purchased")
                SKPaymentQueue.default().finishTransaction(transaction)
                unlockAdFree()
                break
            case .failed:
                print("Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                print("Restored")
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
    
    @IBAction func purchaseTapped(_ sender: Any) {
        
        if products.count != 0 {
            purchaseProduct(product: products[0])
        }
    }
    
    @IBAction func rateTapped(_ sender: Any) {
        
        UIApplication.shared.open(appUrl!, options: [:], completionHandler: nil)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        adFreePurchaseMade = true
        UserDefaults.standard.set(adFreePurchaseMade, forKey: "adFreePurchaseMade")
        
        showAlertWithTitle("GST Calculator", message: "You've successfully restored your purchase!")
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool { return SKPaymentQueue.canMakePayments() }
    
    func purchaseProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
            
            // IAP Purchases dsabled on the Device
        } else {
            showAlertWithTitle("GST Calculator", message: "Purchases are disabled in your device!")
        }
    }
    
    func unlockAdFree() {
        if productID == AD_FREE_ID {
            
            adFreePurchaseMade = true
            UserDefaults.standard.set(adFreePurchaseMade, forKey: "adFreePurchaseMade")
            
            // Action after purchased
            showAlertWithTitle("GST Calculator", message: "You've successfully enabled Ad Free version!")
        }
    }
    
    // Alert
    func showAlertWithTitle(_ title:String, message: String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
