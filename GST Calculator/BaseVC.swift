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
    @IBOutlet weak var priceIncludingTax: UITextField!
    
    var priceExTax = 0.0
    var priceInTax = 0.0
    var taxPercent = 0.0
    var taxPrice = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceExcludingTax.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        priceExcludingTax.resignFirstResponder()
        return true
    }
    
    @IBAction func priceExcludingTaxEdited(_ sender: Any) {
        
        let intValue = Double(priceExcludingTax.text!)!
        priceExTax = intValue
        let strSeperated = intValue.formattedWithSeparator
        priceExcludingTax.text = strSeperated
    }
    
    @IBAction func taxAmountEdited(_ sender: Any) {
        
    }
    
    @IBAction func taxPercentageEdited(_ sender: Any) {
        
        taxPercent = Double(taxPercentage.text!)!
        taxPrice = priceExTax * (taxPercent * 0.01)
        taxAmount.text = "\(taxPrice.round(to: 2))"
        priceInTax = priceExTax + taxPrice
        priceIncludingTax.text = "\(priceInTax.round(to: 2))"
//        taxPercentage.text = "\(taxPercentage.text!)%"
        taxPercentage.text = "\(Double(taxPercentage.text!)!.round(to: 2))%"
    }
    
    @IBAction func priceIncludingTaxEdited(_ sender: Any) {
    }
    
    
    
    
    
    
    
    
}

