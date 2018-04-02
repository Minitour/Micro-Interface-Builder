//
//  UIButton+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 22/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public extension UIButton {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary
            if let p = values["title"]?.stringValue { setTitle(p, for: []) }

            if let p = values["titleColor"]?.colorValue { setTitleColor(p, for: []) }


            if let p = values["fontSize"]?.cgFloatValue{
                if let label = titleLabel {
                    label.font = label.font.withSize(p)
                }
            }

            if let p = values["tintColor"]?.colorValue {
                tintColor = p
            }

            UIView.setAnimationsEnabled(true)

        }get{
            let values:[String : IBProperty] = ["title": .text(title(for: [])),
                                                "titleColor" : .color(titleColor(for: [])),
                                                "fontSize" : .cgfloat(titleLabel?.font.pointSize ?? 0.0)]
            
            return NSDictionary(dictionary: values.merging(super.properties.swiftDictionary, uniquingKeysWith: { $1 }))
        }
    }
}
