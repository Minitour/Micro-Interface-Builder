//
//  UISegmentControl+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 26/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public extension UISegmentedControl {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary
            if let p = values["segment"]?.stringValue {
                let segments =  p.components(separatedBy: ",")
                removeAllSegments()
                for i in 0 ..< segments.count {
                    insertSegment(withTitle: segments[i], at: i, animated: false)
                }
            }

            if let p = values["selectedSegmentIndex"]?.intValue, p < numberOfSegments { selectedSegmentIndex = p}


            if let p = values["tintColor"]?.colorValue {
                tintColor = p
            }

            UIView.setAnimationsEnabled(true)

        }get{
            let values:[String : IBProperty] = ["tintColor" : .color(tintColor),
                                                "segment" : .text(segmentTitlesAsString),
                                                "selectedSegmentIndex" : .number(selectedSegmentIndex)]

            return NSDictionary(dictionary: values.merging(super.properties.swiftDictionary, uniquingKeysWith: { $1 }))
        }
    }

    var segmentTitlesAsString: String {
        var str = ""
        for i in 0 ..< numberOfSegments {
            str.append(titleForSegment(at: i)!)
            if i != numberOfSegments - 1 , numberOfSegments != 1 {
                str.append(",")
            }
        }

        return str
    }
}
