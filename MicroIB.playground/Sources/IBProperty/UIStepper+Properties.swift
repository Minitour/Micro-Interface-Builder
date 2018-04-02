//
//  UIPageControl+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 29/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public extension UIStepper {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary

            if let p = values["tintColor"]?.colorValue { tintColor = p }

            UIView.setAnimationsEnabled(true)

        }get{
            let superVals = super.properties.swiftDictionary

            let values:[String : IBProperty] = [ "tintColor" : .color(tintColor) ]


            return NSDictionary(dictionary: values.merging(superVals, uniquingKeysWith: { $1 }))
        }
    }
}
