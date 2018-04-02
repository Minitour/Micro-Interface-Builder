//
//  UIPageControl+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 29/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public extension UIPageControl {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary

            if let p = values["numberOfPages"]?.intValue { numberOfPages = p }

            if let p = values["currentPage"]?.intValue { currentPage = p }

            if let p = values["currentPageColor"]?.colorValue { currentPageIndicatorTintColor = p }

            if let p = values["tintColor"]?.colorValue { pageIndicatorTintColor = p }

            UIView.setAnimationsEnabled(true)

        }get{
            let superVals = super.properties.swiftDictionary

            let values:[String : IBProperty] = [ "numberOfPages" : .number(numberOfPages) ,
                                                 "currentPage" : .number(currentPage),
                                                 "currentPageColor" : .color(currentPageIndicatorTintColor),
                                                 "tintColor" : .color(pageIndicatorTintColor)]


            return NSDictionary(dictionary: values.merging(superVals, uniquingKeysWith: { $1 }))
        }
    }
}

