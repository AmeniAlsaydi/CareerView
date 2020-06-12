//
//  FloatingLabelTextField.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/10/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

class FloatingLabelInput: UITextField {

    var floatingLabel: UILabel = UILabel(frame: CGRect.zero) // Label
    var floatingLabelHeight: CGFloat = 10 // 14 is Default height
    
    @IBInspectable
    var _placeholder: String? // we cannot override 'placeholder'
    
    @IBInspectable
    var floatingLabelColor: UIColor = #colorLiteral(red: 0.2105118036, green: 0.0652000457, blue: 0.2819291055, alpha: 1)  { //UIColor.black {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            
            self.setNeedsDisplay()
        }
    }
    @IBInspectable
    var activeBorderColor: UIColor = UIColor.blue
    @IBInspectable
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 10, weight: .medium) { //UIFont.systemFont(ofSize: 10) {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder // Use our custom placeholder if none is set
        placeholder = self._placeholder // make sure the placeholder is shown
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
    }
    
    
    // Add a floating label to the view on becoming first responder
    @objc func addFloatingLabel() {
        if self.text == "" {
            self.floatingLabel.textColor = floatingLabelColor
            self.floatingLabel.font = floatingLabelFont
            self.floatingLabel.text = self._placeholder
            self.floatingLabel.layer.backgroundColor = UIColor.clear.cgColor
            self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            self.floatingLabel.clipsToBounds = true
            self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.floatingLabelHeight)
    self.layer.borderColor = self.activeBorderColor.cgColor
            self.addSubview(self.floatingLabel)
          
            self.floatingLabel.bottomAnchor.constraint(equalTo:
            self.topAnchor, constant: -7).isActive = true // Place our label 10pts above the text field
            // Remove the placeholder
            self.placeholder = ""
        }
        self.setNeedsDisplay()
    }
    
    @objc func removeFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
               self.subviews.forEach{ $0.removeFromSuperview() }
               self.setNeedsDisplay()
            }
            self.placeholder = self._placeholder
        }
        self.layer.borderColor = UIColor.black.cgColor
    }
    
      @objc func styleTextField() {
           
           let bottomLine = CALayer()
           bottomLine.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 1)
           bottomLine.backgroundColor = UIColor.lightGray.cgColor
           self.borderStyle = .none
           self.layer.addSublayer(bottomLine)
       }
       

}
