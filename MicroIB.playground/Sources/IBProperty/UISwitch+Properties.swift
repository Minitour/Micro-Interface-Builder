//
//  UISwitch+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 26/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public extension UISwitch {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary
            
            if let p = values["onTintColor"]?.colorValue { onTintColor = p }

            if let p = values["thumbTintColor"]?.colorValue { thumbTintColor = p }

            if let p = values["isOn"]?.boolValue { isOn = p }

            UIView.setAnimationsEnabled(true)

        }get{
            var superVals = super.properties.swiftDictionary
            superVals["backgroundColor"] = nil
            superVals["cornerRadius"] = nil
            superVals["masksToBounds"] = nil

            let values:[String : IBProperty] = ["onTintColor": .color(onTintColor),
                                                "thumbTintColor": .color(thumbTintColor),
                                                "isOn" : .boolean(isOn)]

            return NSDictionary(dictionary: values.merging(superVals, uniquingKeysWith: { $1 }))
        }
    }
}
