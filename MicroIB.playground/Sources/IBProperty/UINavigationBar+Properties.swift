//
//  UINavigationBar+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 29/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public extension UINavigationBar {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary

            if let p = values["title"]?.stringValue {
                let navigationItem = UINavigationItem(title: p)
                setItems([navigationItem], animated: false)
            }

            if let p = values["isTranslucent"]?.boolValue { isTranslucent = p }

            if let p = values["barTint"]?.colorValue { barTintColor = p }

            if let textColor = values["textColor"]?.colorValue,
                let fontSize = values["fontSize"]?.cgFloatValue,
                let boldFont = values["boldFont"]?.boolValue {
                let font = boldFont ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
                let textAttributes = [NSAttributedStringKey.foregroundColor : textColor,
                                      NSAttributedStringKey.font : font]
                titleTextAttributes = textAttributes
            }


            UIView.setAnimationsEnabled(true)

        }get{
            var superVals = super.properties.swiftDictionary
            superVals["backgroundColor"] = nil
            superVals["cornerRadius"] = nil
            superVals["masksToBounds"] = nil

            let font = titleTextAttributes?[NSAttributedStringKey.font] as? UIFont

            let values:[String : IBProperty] = [ "title" : .text(items?.first?.title ?? ""),
                                                 "isTranslucent" : .boolean(isTranslucent),
                                                 "barTint" : .color(barTintColor),
                                                 "textColor" : .color(titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor),
                                                 "fontSize" : .cgfloat(font?.pointSize ?? 0),
                                                 "boldFont" : .boolean(font?.isBold ?? false)]


            return NSDictionary(dictionary: values.merging(superVals, uniquingKeysWith: { $1 }))
        }
    }
}
