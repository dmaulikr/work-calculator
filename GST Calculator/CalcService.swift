//
//  CalcService.swift
//  Retro Calculator
//
//  Created by Andrew Foster on 5/31/17.
//  Copyright © 2017 Foster Inc. All rights reserved.
//

import UIKit

class CalcService {
    static let shared = CalcService()
    
    enum Operation: String {
        case divide = "÷"
        case multiply = "×"
        case subtract = "−"
        case add = "+"
        case empty = ""
    }
    
    func multiply(numAstr: String, numBstr: String) -> String? {
        
        if let numA = Double(numAstr), let numB = Double(numBstr) {
            return "\(numA * numB)"
        } else {
            return nil
        }
    }
    
    func subtract(numAstr: String, numBstr: String) -> String? {
        
        if let numA = Double(numAstr), let numB = Double(numBstr) {
            return "\(numA - numB)"
        } else {
            return nil
        }
    }
    
    func divide(numAstr: String, numBstr: String) -> String? {
        
        if let numA = Double(numAstr), let numB = Double(numBstr) {
            return "\(numA / numB)"
        } else {
            return nil
        }
    }
    
    func add(numAstr: String, numBstr: String) -> String? {
        
        if let numA = Double(numAstr), let numB = Double(numBstr) {
            return "\(numA + numB)"
        } else {
            return nil
        }
    }
}

