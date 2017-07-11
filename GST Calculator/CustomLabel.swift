//
//  CustomLabel.swift
//  GST Calculator
//
//  Created by Andrii Halabuda on 7/11/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit

@IBDesignable
class CustomLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}
