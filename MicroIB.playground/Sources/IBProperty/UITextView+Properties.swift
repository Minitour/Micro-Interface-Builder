//
//  UITextView+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 26/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public extension UITextView {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary
            if let p = values["text"]?.stringValue { text = p }

            if let p = values["titleColor"]?.colorValue { textColor = p }

            if let p = values["fontSize"]?.cgFloatValue{
                font = font?.withSize(p)
            }

            if let p = values["boldFont"]?.boolValue {
                if p {
                    font = font?.bold
                }else{
                    font = font?.normal
                }
            }

            if let p = values["textAlignment"]?.segmentItemValue {
                textAlignment = NSTextAlignment(rawValue: p.selectedItem) ?? .center
            }

            if let p = values["tintColor"]?.colorValue {
                tintColor = p
            }

            UIView.setAnimationsEnabled(true)

        }get{
            let values:[String : IBProperty] = ["text": .text(text),
                                                "titleColor" : .color(textColor),
                                                "fontSize" : .cgfloat(font?.pointSize ?? 0.0),
                                                "boldFont": .boolean(font?.isBold ?? false),
                                                "textAlignment" : .enumeration(SegmentDataItem(selectedItem: selectedAlighmentAsInt, options: ["Left","Center","Right"]))]

            return NSDictionary(dictionary: values.merging(super.properties.swiftDictionary, uniquingKeysWith: { $1 }))
        }
    }

    var selectedAlighmentAsInt: Int {
        switch textAlignment {

        case .left:
            return 0
        case .center:
            return 1
        case .right:
            return 2
        default:
            return 1
        }
    }
}
