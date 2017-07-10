//  CustomTextField.swift

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 10
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }  
    }
    
    @IBInspectable var textReturned: String = "" {
        didSet {
            return self.text = "$\(textReturned)"
        }  
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
    
}
