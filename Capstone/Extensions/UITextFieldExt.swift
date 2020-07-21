//
//  UITextFieldExt.swift
//  Capstone
//
//  Created by Amy Alsaydi on 6/10/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.layer.backgroundColor = UIColor.white.cgColor
        self.borderStyle = .none
    }
    func setBottomBorder() {
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    public func setBorder(color: CGColor?, width: CGFloat) {
        self.layer.borderWidth = width
        if color != nil {
            self.layer.borderColor = color
        } else {
            self.layer.borderColor = nil
        }
    }
}
