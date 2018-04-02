//
//  UIImageView+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 24/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public extension UIImageView {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary

            image = values["image"]?.imageValue

            if let p = values["contentMode"]?.segmentItemValue {
                contentMode = UIViewContentMode(rawValue: p.selectedItem) ?? .scaleToFill
            }


            UIView.setAnimationsEnabled(true)

        }get{
            let values:[String : IBProperty] = ["image": .image(image),
                                                "contentMode" : .enumeration(SegmentDataItem(selectedItem: contentMode.rawValue,
                                                                                             options: ["1",
                                                                                                       "2",
                                                                                                       "3"]))]

            return NSDictionary(dictionary: values.merging(super.properties.swiftDictionary, uniquingKeysWith: { $1 }))
        }
    }
}
