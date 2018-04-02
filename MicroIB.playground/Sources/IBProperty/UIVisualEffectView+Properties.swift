//
//  UIVisualEffectView+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 30/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public extension UIVisualEffectView {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue
            let values = newValue.swiftDictionary

            if let p = values["blurEffect"]?.segmentItemValue?.selectedItem {
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle(rawValue: p) ?? .light)
                self.effect = blurEffect
            }


            UIView.setAnimationsEnabled(true)

        }get{
            let values:[String : IBProperty] = ["blurEffect" : .enumeration(SegmentDataItem(selectedItem: self.effect!.value(forKey: "style") as! Int,
                                                                                            options: ["1",
                                                                                                      "2",
                                                                                                      "3"]))]

            return NSDictionary(dictionary: values.merging(super.properties.swiftDictionary, uniquingKeysWith: { $1 }))
        }
    }
}
