//
//  SecondScreenVC.swift
//  GST Calculator
//
//  Created by Andrii Halabuda on 7/25/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit

class SecondScreenVC: UIViewController {
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var keyboard: UIStackView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var subtractBtn: UIButton!
    @IBOutlet weak var multiplyBtn: UIButton!
    @IBOutlet weak var divideBtn: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var bgView: CustomView!
    @IBOutlet weak var percentageLbl: UILabel!
    @IBOutlet weak var taxAmountLbl: UILabel!
    @IBOutlet weak var totalCalculatedLbl: UILabel!
    
    var startAppBanner: STABannerView?
    
    // Variables for calculations
    var runningNumber = "0"
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    var currentOperation = CalcService.Operation.empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputLabel.text = basePrice.round(to: 2).formattedWithSeparator
        percentageLbl.text = percentOnLbl
        taxAmountLbl.text = taxableAmount2.round(to: 2).formattedWithSeparator
        totalCalculatedLbl.text = totalPrice2.round(to: 2).formattedWithSeparator
        
        print("Purchased:", adFreePurchaseMade)
        
        if adFreePurchaseMade {
            // Close Ad
        } else {
            showBannerAd()
        }
        
    }
    
    func showBannerAd() {
        if startAppBanner == nil {
            startAppBanner = STABannerView(size: STA_AutoAdSize, origin: CGPoint(x: 0, y: 160), with: self.view, withDelegate: nil)
            self.view.insertSubview(startAppBanner!, belowSubview: keyboard)
        }
    }
    
    @IBAction func percentagePressed(_ btn: UIButton!) {
        
        if outputLabel.text == nil || outputLabel.text == "" {
            print("No base price")
            basePrice = 0.0
            
        } else {
            
            if basePrice != 0.0 {
                
                if btn.tag == 12 {
                    percentageLbl.text = "+28%"
                    percentOnLbl = "+28%"
                    taxPercent2 = 0.28
                    updateLables()
                } else if btn.tag == 13 {
                    percentageLbl.text = "+18%"
                    percentOnLbl = "+18%"
                    taxPercent2 = 0.18
                    updateLables()
                } else if btn.tag == 14 {
                    percentageLbl.text = "+12%"
                    percentOnLbl = "+12%"
                    taxPercent2 = 0.12
                    updateLables()
                } else if btn.tag == 15 {
                    percentageLbl.text = "+5%"
                    percentOnLbl = "+5%"
                    taxPercent2 = 0.05
                    updateLables()
                } else if btn.tag == 16 {
                    percentageLbl.text = "+3%"
                    percentOnLbl = "+3%"
                    taxPercent2 = 0.03
                    updateLables()
                } else if btn.tag == 17 {
                    percentageLbl.text = "-28%"
                    percentOnLbl = "-28%"
                    taxPercent2 = 0.28
                    updateLablesMinus()
                } else if btn.tag == 18 {
                    percentageLbl.text = "-18%"
                    percentOnLbl = "-18%"
                    taxPercent2 = 0.18
                    updateLablesMinus()
                } else if btn.tag == 19 {
                    percentageLbl.text = "-12%"
                    percentOnLbl = "-12%"
                    taxPercent2 = 0.12
                    updateLablesMinus()
                } else if btn.tag == 20 {
                    percentageLbl.text = "-5%"
                    percentOnLbl = "-5%"
                    taxPercent2 = 0.05
                    updateLablesMinus()
                } else if btn.tag == 21 {
                    percentageLbl.text = "-3%"
                    percentOnLbl = "-3%"
                    taxPercent2 = 0.03
                    updateLablesMinus()
                }
            }
        }
    }
    
    func updateLables() {
        taxableAmount2 = basePrice * taxPercent2
        totalPrice2 = basePrice + taxableAmount2
        taxAmountLbl.text = taxableAmount2.round(to: 2).formattedWithSeparator
        totalCalculatedLbl.text = totalPrice2.round(to: 2).formattedWithSeparator
        outputLabel.text = basePrice.round(to: 2).formattedWithSeparator
    }
    
    func updateLablesMinus() {
        taxableAmount2 = basePrice * taxPercent2
        totalPrice2 = basePrice - taxableAmount2
        taxAmountLbl.text = taxableAmount2.round(to: 2).formattedWithSeparator
        totalCalculatedLbl.text = totalPrice2.round(to: 2).formattedWithSeparator
        outputLabel.text = basePrice.round(to: 2).formattedWithSeparator
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
        
        outputLabel.text = runningNumber
        if let num = Double(runningNumber) {
            basePrice = num
        }
//        basePrice = Double(runningNumber)!
    }
    
    @IBAction func dotTapped(_ btn: UIButton!) {
        
        runningNumber += "."
        outputLabel.text = runningNumber
        
        if runningNumber == "." || runningNumber == "0" || runningNumber == "0." || runningNumber == "0.." || runningNumber == "0..." || runningNumber == "0...." || runningNumber == "0....." || runningNumber == "0......." || runningNumber == "0......." {
            runningNumber = "0."
            basePrice = 0.0
        } else {
            if let num = Double(runningNumber) {
                basePrice = num
            }
//            basePrice = Double(runningNumber)!
        }
    }
    
    @IBAction func onDividePressed(_ sender: AnyObject) {
        processOperation(CalcService.Operation.divide)
    }
    
    @IBAction func onMultiplyPressed(_ sender: AnyObject) {
        processOperation(CalcService.Operation.multiply)
    }
    
    @IBAction func onSubtractPressed(_ sender: AnyObject) {
        processOperation(CalcService.Operation.subtract)
    }
    
    @IBAction func onAddPressed(_ sender: AnyObject) {
        processOperation(CalcService.Operation.add)
    }
    
    @IBAction func onEqualPressed(_ sender: AnyObject) {
        processOperation(currentOperation)
        
        outputLabel.text = String(basePrice.round(to: 2).formattedWithSeparator)
    }
    
    @IBAction func onClearPressed(_ sender: AnyObject) {
        
        runningNumber = "0"
        leftValStr = ""
        rightValStr = ""
        result = ""
        currentOperation = CalcService.Operation.empty
        
        outputLabel.text = "0"
        percentageLbl.text = "%"
        taxAmountLbl.text = "0"
        totalCalculatedLbl.text = "0"
        basePrice = 0.0
        taxPercent2 = 0.0
        taxableAmount2 = 0.0
        totalPrice2 = 0.0
    }
    
    @IBAction func delTapped(_ sender: AnyObject) {
        
        if runningNumber != "" {
            
            runningNumber = String(runningNumber.characters.dropLast())
            outputLabel.text = runningNumber
            
            if runningNumber == "" {
                runningNumber = "0"
                outputLabel.text = runningNumber
            }
            
        } else {
            
            runningNumber = "0"
            outputLabel.text = ""
        }
        
        if runningNumber == "0" {
            outputLabel.text = "0"
        }
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
                basePrice = Double(result)!.round(to: 2)
                outputLabel.text = String(basePrice.formattedWithSeparator)
            }
            
            currentOperation = operation
            print("CO:", currentOperation)
            
        } else {
            
            // This is the first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = "0"
            currentOperation = operation
        }
    }
    
}
