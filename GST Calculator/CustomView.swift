//
//  CustomView.swift
//  GST Calculator
//
//  Created by Andrew Foster on 7/11/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
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
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
    }
    
}
