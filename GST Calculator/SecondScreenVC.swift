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
                    basePrice += (basePrice * 0.28)
                } else if btn.tag == 13 {
                    basePrice += (basePrice * 0.18)
                } else if btn.tag == 14 {
                    basePrice += (basePrice * 0.12)
                } else if btn.tag == 15 {
                    basePrice += (basePrice * 0.05)
                } else if btn.tag == 16 {
                    basePrice += (basePrice * 0.03)
                } else if btn.tag == 17 {
                    basePrice -= (basePrice * 0.28)
                } else if btn.tag == 18 {
                    basePrice -= (basePrice * 0.18)
                } else if btn.tag == 19 {
                    basePrice -= (basePrice * 0.12)
                } else if btn.tag == 20 {
                    basePrice -= (basePrice * 0.05)
                } else if btn.tag == 21 {
                    basePrice -= (basePrice * 0.03)
                }
                
                leftValStr = String(basePrice.round(to: 2))
                outputLabel.text = basePrice.round(to: 2).formattedWithSeparator
            } else {
                
                if leftValStr != "" {
                    basePrice = Double(leftValStr)!
                
                if btn.tag == 12 {
                    basePrice += (basePrice * 0.28)
                } else if btn.tag == 13 {
                    basePrice += (basePrice * 0.18)
                } else if btn.tag == 14 {
                    basePrice += (basePrice * 0.12)
                } else if btn.tag == 15 {
                    basePrice += (basePrice * 0.05)
                } else if btn.tag == 16 {
                    basePrice += (basePrice * 0.03)
                } else if btn.tag == 17 {
                    basePrice -= (basePrice * 0.28)
                } else if btn.tag == 18 {
                    basePrice -= (basePrice * 0.18)
                } else if btn.tag == 19 {
                    basePrice -= (basePrice * 0.12)
                } else if btn.tag == 20 {
                    basePrice -= (basePrice * 0.05)
                } else if btn.tag == 21 {
                    basePrice -= (basePrice * 0.03)
                }
                
                leftValStr = String(basePrice.round(to: 2))
                outputLabel.text = basePrice.round(to: 2).formattedWithSeparator
                }
            }
            
        }
        
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
        
        basePrice = Double(runningNumber)!
    }
    
    @IBAction func dotTapped(_ btn: UIButton!) {
        
        runningNumber += "."
        outputLabel.text = runningNumber
        
        basePrice = Double(runningNumber)!
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
        basePrice = 0.0
    }
    
    @IBAction func delTapped(_ sender: AnyObject) {
        
        if runningNumber != "" {
            
            runningNumber = String(runningNumber.characters.dropLast())
            outputLabel.text = runningNumber
//            basePrice = Double(runningNumber)!
            
            if runningNumber == "" {
                runningNumber = "0"
                outputLabel.text = runningNumber
//                basePrice = Double(runningNumber)!
            }
            
        } else {
            
            runningNumber = "0"
            outputLabel.text = ""
//            basePrice = Double(runningNumber)!
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
