//
//  ViewController.swift
//  Store
//
//  Created by Andrew Foster on 6/6/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit
import CoreData
import StoreKit

class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var ADs = [Ad]()
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestProducts()
    }
    
    // Request products from Apple
    func requestProducts() {
        let ids : Set<String> = ["com.losAngelesBoy.Store.tree"]
        let productsRequest = SKProductsRequest(productIdentifiers: ids)
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
    func unlockArt(_ productIdentifier: String) {
        
        if ADs[0].productIdentifier == productIdentifier {
            ADs[0].purchased = true
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            do {
                try context.save()
            } catch {}
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ad = self.ADs[0]
        if !ad.purchased {
            for product in self.products {
                if product.productIdentifier == ad.productIdentifier {
                    SKPaymentQueue.default().add(self)
                    let payment = SKPayment(product: product)
                    SKPaymentQueue.default().add(payment)
                }
            }
        }
    }

}

