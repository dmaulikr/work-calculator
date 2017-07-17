//
//  ViewController.swift
//  GST Calculator
//
//  Created by Andrew Foster on 7/9/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BaseVC: UIViewController, UITextFieldDelegate, GADBannerViewDelegate {
    
    @IBOutlet weak var priceExcludingTax: UITextField!
    @IBOutlet weak var taxAmount: UITextField!
    @IBOutlet weak var taxPercentage: UITextField!
    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var output: UILabel!
    @IBOutlet weak var operatorLbl: UILabel!
    @IBOutlet weak var leftOperand: UILabel!
    @IBOutlet weak var keyboard: UIStackView!
    @IBOutlet weak var doneButton: CustomButton!
    @IBOutlet weak var tapToChangeLbl: UILabel!
    @IBOutlet weak var banner: GADBannerView!
    
    let adUnit = "---" //<-- add ad unit !!!
    let deviceId = "7bec43178b0dc3ccca0a19a8407c1016"
    
    // Basic variables
    var rawPrice = 0.0
    var totalPrice = 0.0
    var taxPercent = 1.0
    var taxableAmount = 0.0
    
    // Variables for calculations
    var runningNumber = "0"
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    var currentOperation = CalcService.Operation.empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceExcludingTax.delegate = self
        taxAmount.delegate = self
        taxPercentage.delegate = self
        total.delegate = self
        
        addObserverForKeyboard()
        
        print("Purchased:", adFreePurchaseMade)
        
        banner.rootViewController = self
        banner.delegate = self
        
        if adFreePurchaseMade {
            // Close Ad
        } else {
            loadAd(adUnitID: adUnit)
        }
        
        let left = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(BaseVC.swipeAction))
        left.edges = .left
        self.view.addGestureRecognizer(left)
    }
    
    //Keyboard dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        doneButton.isHidden = true
        
        priceExcludingTax.layer.borderWidth = 0.0
        taxAmount.layer.borderWidth = 0.0
        total.layer.borderWidth = 0.0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        priceExcludingTax.resignFirstResponder()
        taxAmount.resignFirstResponder()
        taxPercentage.resignFirstResponder()
        total.resignFirstResponder()
        return true
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        doneButton.isHidden = true
        
        priceExcludingTax.layer.borderWidth = 0.0
        taxAmount.layer.borderWidth = 0.0
        total.layer.borderWidth = 0.0
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
        
        tapToChangeLbl.layer.opacity = 1.0
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
    
    @IBAction func beginEditing(_ sender: Any) {
        
        runningNumber = "0"
        leftValStr = ""
        rightValStr = ""
        output.text = ""
        operatorLbl.text = ""
        leftOperand.text = ""
        result = ""
        currentOperation = CalcService.Operation.empty
        
        priceExcludingTax.layer.borderWidth = 1.0
        taxAmount.layer.borderWidth = 0.0
        total.layer.borderWidth = 0.0
        priceExcludingTax.layer.borderColor = UIColor.orange.cgColor
    }
    
    @IBAction func beginEditingAmount(_ sender: Any) {
        
        runningNumber = "0"
        leftValStr = ""
        rightValStr = ""
        output.text = ""
        operatorLbl.text = ""
        leftOperand.text = ""
        result = ""
        currentOperation = CalcService.Operation.empty
        
        priceExcludingTax.layer.borderWidth = 0.0
        taxAmount.layer.borderWidth = 1.0
        total.layer.borderWidth = 0.0
        taxAmount.layer.borderColor = UIColor.orange.cgColor
    }
    
    @IBAction func beginEditingTotal(_ sender: Any) {
        
        runningNumber = "0"
        leftValStr = ""
        rightValStr = ""
        output.text = ""
        operatorLbl.text = ""
        leftOperand.text = ""
        result = ""
        currentOperation = CalcService.Operation.empty
        
        priceExcludingTax.layer.borderWidth = 0.0
        taxAmount.layer.borderWidth = 0.0
        total.layer.borderWidth = 1.0
        total.layer.borderColor = UIColor.orange.cgColor
    }
    
    @IBAction func beginEditingPercentage(_ sender: Any) {
        priceExcludingTax.layer.borderWidth = 0.0
        taxAmount.layer.borderWidth = 0.0
        total.layer.borderWidth = 0.0
        
        tapToChangeLbl.layer.opacity = 0.25
    }
    
    //Keyboard frame sizing
    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
        keyboard.isHidden = true
        doneButton.isHidden = false
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0 {
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
        keyboard.isHidden = false
        doneButton.isHidden = true
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
    
    func swipeAction() {
        performSegue(withIdentifier: "goSettings", sender: nil)
    }
    
    func loadAd(adUnitID: String) {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, deviceId]
        
        banner.adUnitID = adUnitID
        banner.load(request)
    }
    
    //******************************
    //***Calculator functionality***
    //******************************
    
    @IBAction func numberPressed(_ btn: UIButton!) {
        
        if runningNumber != "0" {
            runningNumber += "\(btn.tag)"
        } else {
            runningNumber = ""
            runningNumber += "\(btn.tag)"
        }
        output.text = runningNumber
    }
    
    @IBAction func dotTapped(_ btn: UIButton!) {
        
        runningNumber += "."
        output.text = runningNumber
    }
    
    @IBAction func onDividePressed(_ sender: AnyObject) {
        processOperation(CalcService.Operation.divide)
        operatorLbl.text = currentOperation.rawValue
        leftOperand.text = leftValStr
    }
    
    @IBAction func onMultiplyPressed(_ sender: AnyObject) {
        processOperation(CalcService.Operation.multiply)
        operatorLbl.text = currentOperation.rawValue
        leftOperand.text = leftValStr
    }
    
    @IBAction func onSubtractPressed(_ sender: AnyObject) {
        processOperation(CalcService.Operation.subtract)
        operatorLbl.text = currentOperation.rawValue
        leftOperand.text = leftValStr
    }
    
    @IBAction func onAddPressed(_ sender: AnyObject) {
        processOperation(CalcService.Operation.add)
        operatorLbl.text = currentOperation.rawValue
        leftOperand.text = leftValStr
    }
    
    @IBAction func onEqualPressed(_ sender: AnyObject) {
        processOperation(currentOperation)
//        if runningNumber == "" {
//            runningNumber = "0"
//        }
    }
    
    @IBAction func onClearPressed(_ sender: AnyObject) {
        
        runningNumber = "0"
        leftValStr = ""
        rightValStr = ""
        output.text = ""
        result = ""
        currentOperation = CalcService.Operation.empty
        leftOperand.text = leftValStr
        operatorLbl.text = currentOperation.rawValue
        
        priceExcludingTax.text = ""
        taxAmount.text = ""
        total.text = ""
        
        rawPrice = 0.0
        taxableAmount = 0.0
        totalPrice = 0.0
    }
    
    @IBAction func delTapped(_ sender: AnyObject) {
        
        if runningNumber != "" {
            
            runningNumber = String(runningNumber.characters.dropLast())
            output.text = runningNumber
            
            if runningNumber == "" {
                runningNumber = "0"
                output.text = "0"
            }
            
        } else {
            runningNumber = "0"
            output.text = ""
        }
        leftOperand.text = leftValStr
    }
    
    func processOperation(_ operation: CalcService.Operation) {
        
        if currentOperation != CalcService.Operation.empty {
            
            // A user selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == CalcService.Operation.multiply {
                    if let res = CalcService.shared.multiply(numAstr: leftValStr, numBstr: rightValStr) {
                        result = res
                    } else {
                        result = "0"
                        print("NO return value")
                    }
                    
                } else if currentOperation == CalcService.Operation.divide {
                    if let res = CalcService.shared.divide(numAstr: leftValStr, numBstr: rightValStr) {
                        result = res
                    } else {
                        result = "0"
                        print("NO return value")
                    }
                    
                } else if currentOperation == CalcService.Operation.subtract {
                    if let res = CalcService.shared.subtract(numAstr: leftValStr, numBstr: rightValStr) {
                        result = res
                    } else {
                        result = "0"
                        print("NO return value")
                    }
                    
                } else if currentOperation == CalcService.Operation.add {
                    if let res = CalcService.shared.add(numAstr: leftValStr, numBstr: rightValStr) {
                        result = res
                    } else {
                        result = "0"
                        print("NO return value")
                    }
                }
                
                leftValStr = result
                output.text = rightValStr
                priceExcludingTax.text = result
                priceExcludingTaxEdited((Any).self)
                
            }
            
            currentOperation = operation
            print("CO:", currentOperation)
            operatorLbl.text = operation.rawValue
            
        } else {
            
            // This is the first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = "0"
            currentOperation = operation
        }
    }
    
}

