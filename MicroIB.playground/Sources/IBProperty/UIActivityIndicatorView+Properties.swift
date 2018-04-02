//
//  UIActivityIndicator+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 26/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public extension UIActivityIndicatorView {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary

            if let p = values["style"]?.segmentItemValue {
                activityIndicatorViewStyle = UIActivityIndicatorViewStyle(rawValue: p.selectedItem) ?? .gray
            }

            if let p = values["color"]?.colorValue {
                color = p
            }

            UIView.setAnimationsEnabled(true)

        }get{
            var superVals = super.properties.swiftDictionary
            superVals["backgroundColor"] = nil
            superVals["cornerRadius"] = nil
            superVals["masksToBounds"] = nil

            let values:[String : IBProperty] = ["color": .color(color),
                                                "style" : .enumeration(SegmentDataItem(selectedItem: activityIndicatorViewStyle.rawValue, options: ["1","2","3"]))]

            return NSDictionary(dictionary: values.merging(superVals, uniquingKeysWith: { $1 }))
        }
    }
}
