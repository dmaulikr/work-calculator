//
//  ViewController.swift
//  GST Calculator
//
//  Created by Andrew Foster on 7/9/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit

class BaseVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var priceExcludingTax: UITextField!
    @IBOutlet weak var taxAmount: UITextField!
    @IBOutlet weak var taxPercentage: UITextField!
    @IBOutlet weak var total: UITextField!
    
    var rawPrice = 0.0
    var totalPrice = 0.0
    var taxPercent = 1.0
    var taxableAmount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceExcludingTax.delegate = self
        taxAmount.delegate = self
        taxPercentage.delegate = self
        total.delegate = self
        priceExcludingTax.becomeFirstResponder()
        
        addObserverForKeyboard()
    }
    
    //Keyboard dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        priceExcludingTax.resignFirstResponder()
        taxAmount.resignFirstResponder()
        taxPercentage.resignFirstResponder()
        total.resignFirstResponder()
        return true
    }
    
    @IBAction func priceExcludingTaxEdited(_ sender: Any) {
        
        if priceExcludingTax.text == nil || priceExcludingTax.text == "" {
            print("No raw price")
            rawPrice = 0.0
            taxAmount.text = ""
            total.text = ""
            
            taxableAmount = 0.0
            totalPrice = 0.0
        } else {
            
            if let value = Double(priceExcludingTax.text!) {
                rawPrice = value
                
                taxableAmount = rawPrice * (taxPercent * 0.01)
                totalPrice = rawPrice + taxableAmount
                
                taxAmount.text = taxableAmount.round(to: 2).formattedWithSeparator
                total.text = totalPrice.round(to: 2).formattedWithSeparator
                priceExcludingTax.text = rawPrice.round(to: 2).formattedWithSeparator
            }
        }
    }
    
    @IBAction func taxAmountEdited(_ sender: Any) {
        if taxAmount.text == nil || taxAmount.text == "" {
            print("No tax amount")
            taxableAmount = 0.0
            priceExcludingTax.text = ""
            total.text = ""
            
            rawPrice = 0.0
            totalPrice = 0.0
        } else {
            
            if let value = Double(taxAmount.text!) {
                taxableAmount = value
                
                rawPrice = taxableAmount * 100 / taxPercent
                totalPrice = rawPrice + taxableAmount
                
                taxAmount.text = taxableAmount.round(to: 2).formattedWithSeparator
                total.text = totalPrice.round(to: 2).formattedWithSeparator
                priceExcludingTax.text = rawPrice.round(to: 2).formattedWithSeparator
            }
        }
    }
    
    @IBAction func taxPercentageEdited(_ sender: Any) {
        
        if taxPercentage.text == nil || taxPercentage.text == "" {
            print("Default tax")
            taxPercent = 1.0
            taxPercentage.text = "1.0%"
            
            if priceExcludingTax.text == nil || priceExcludingTax.text == "" {
                print("No raw value")
                
            } else {
                taxableAmount = rawPrice * (taxPercent * 0.01)
                totalPrice = rawPrice + taxableAmount
                
                taxAmount.text = taxableAmount.round(to: 2).formattedWithSeparator
                total.text = totalPrice.round(to: 2).formattedWithSeparator
            }
            
        } else {
            taxPercent = Double(taxPercentage.text!)!
            taxableAmount = rawPrice * (taxPercent * 0.01)
            totalPrice = rawPrice + taxableAmount
            
            taxAmount.text = taxableAmount.round(to: 2).formattedWithSeparator
            total.text = totalPrice.round(to: 2).formattedWithSeparator
            taxPercentage.text = "\(taxPercent.round(to: 2))%"
        }
    }
    
    @IBAction func totalEdited(_ sender: Any) {
        if total.text == nil || total.text == "" {
            print("No Total")
            totalPrice = 0.0
            priceExcludingTax.text = ""
            taxAmount.text = ""
            
            rawPrice = 0.0
            taxableAmount = 0.0
        } else {
            
            if let value = Double(total.text!) {
                totalPrice = value
                
                rawPrice = (totalPrice * 100) / (taxPercent + 100)
                taxableAmount = rawPrice * (taxPercent * 0.01)
                
                taxAmount.text = taxableAmount.round(to: 2).formattedWithSeparator
                total.text = totalPrice.round(to: 2).formattedWithSeparator
                priceExcludingTax.text = rawPrice.round(to: 2).formattedWithSeparator
            }
        }
    }
    
    //Keyboard frame sizing
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func addObserverForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func showAlertWithTitle(_ title:String, message:String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
}

