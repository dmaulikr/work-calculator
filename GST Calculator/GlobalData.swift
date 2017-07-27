//
//  GlobalData.swift
//  GST Calculator
//
//  Created by Andrii Halabuda on 7/15/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import Foundation

var adFreePurchaseMade = UserDefaults.standard.bool(forKey: "adFreePurchaseMade")

// Basic variables
var rawPrice = 0.0
var totalPrice = 0.0
var taxPercent = 1.0
var taxableAmount = 0.0

var basePrice = 0.0
var totalPrice2 = 0.0
var taxPercent2 = 0.0
var taxableAmount2 = 0.0
var percentOnLbl = ""
