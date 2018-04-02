//
//  TextPropertyCell.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 24/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit


public class TextPropertyCell: IBInspectableCell {

    fileprivate lazy var textField: AZTextField = {
        let textField = AZTextField()
        textField.borderStyle = .roundedRect
        textField.onTextChanged = didTextChange
        return textField
    }()

    override func didUpdateKey(withProperty property: IBProperty) {
        let value: String
        switch property.type {
        case .text:
            if let val = property.stringValue {
                value = "\(val)"
            }else {
                value = ""
            }
        case .number:
            if let val = property.intValue {
                value = "\(val)"
            }else {
                value = ""
            }
        case .float:
            if let val = property.floatValue {
                value = "\(val)"
            }else {
                value = ""
            }
        case .cgfloat:
            if let val = property.cgFloatValue {
                value = "\(val)"
            }else {
                value = ""
            }
        default:
            value = ""
        }
        textField.text = value
    }

    override func didFinishSetup() {
        stackView.addArrangedSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }

    func didTextChange(textField: UITextField){
        let value = textField.text!
        var converted: Any?
        if case .text? = property?.type {
            converted = value
        }

        if case .float? = property?.type{
            converted = Float(value) ?? 0.0
        }

        if case .cgfloat? = property?.type {
            converted = CGFloat(Float(value) ?? 0.0)
        }

        if case .number? = property?.type {
            converted = Int(value) ?? 0
        }

        property?.value = converted
        if let prop = property, let key = key,converted != nil {
            draggable?.contentView?.setProperty(key: key, value: prop)
        }
    }
}

