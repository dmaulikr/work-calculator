//
//  SettingsVC.swift
//  GST Calculator
//
//  Created by Andrew Foster on 7/11/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit
import CoreData
import StoreKit

class SettingsVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var ADs = [Ad]()
    var products = [SKProduct]()
    let appUrl = URL(string: "itms-apps://itunes.apple.com/app/id1178333093") //<- Change!!!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if ADs.count == 0 {
            updateContent()
        }
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
                unlockAdFree(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                print("Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                print("Restored")
                unlockAdFree(transaction.payment.productIdentifier)
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
    func unlockAdFree(_ productIdentifier:String) {
        if ADs[0].productIdentifier == productIdentifier {
            ADs[0].purchased = true
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            do {
                try context.save()
            } catch {}
        }
    }
    
    func updateContent() {
        createAd("BannerAd", productIdentifier: "com.andriiHalabuda.GSTCalculator.ad", purchased: false)
    }
    
    // Creating ad from CoreData Entity -Ad-
    func createAd(_ title:String, productIdentifier:String, purchased:Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Ad", in: context) {
            let ad = NSManagedObject(entity: entity, insertInto: context) as! Ad
            ad.title = title
            ad.productIdentifier = productIdentifier
            ad.purchased = purchased
        }
        
        do {
            try context.save()
        } catch {}
    }
    
    @IBAction func purchaseTapped(_ sender: Any) {
        let ad = self.ADs[0]
        if !ad.purchased {
            if products[0].productIdentifier == ad.productIdentifier {
                SKPaymentQueue.default().add(self)
                let payment = SKPayment(product: products[0])
                SKPaymentQueue.default().add(payment)
            }
        }
    }
    
    @IBAction func rateTapped(_ sender: Any) {
        
        UIApplication.shared.open(appUrl!, options: [:], completionHandler: nil)
    }
}
