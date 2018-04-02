//
//  UISlider+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 26/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public extension UISlider {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary

            if let p = values["value"]?.floatValue { value = p }

            if let p = values["minimumTrackTintColor"]?.colorValue { minimumTrackTintColor = p }

            if let p = values["maximumTrackTintColor"]?.colorValue { maximumTrackTintColor = p }

            if let p = values["thumbTintColor"]?.colorValue { thumbTintColor = p }

            if let p = values["tintColor"]?.colorValue { tintColor = p }

            UIView.setAnimationsEnabled(true)

        }get{
            var superVals = super.properties.swiftDictionary
            superVals["backgroundColor"] = nil
            superVals["cornerRadius"] = nil
            superVals["masksToBounds"] = nil

            let values:[String : IBProperty] = ["tintColor": .color(tintColor),
                                                "minimumTrackTintColor": .color(minimumTrackTintColor),
                                                "maximumTrackTintColor" : .color(maximumTrackTintColor),
                                                "thumbTintColor" : .color(thumbTintColor),
                                                "value" : .precent(value) ]

            return NSDictionary(dictionary: values.merging(superVals, uniquingKeysWith: { $1 }))
        }
    }
}

