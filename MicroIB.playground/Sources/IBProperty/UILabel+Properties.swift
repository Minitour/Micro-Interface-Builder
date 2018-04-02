//
//  UILabel+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 24/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {

    public override var properties: NSDictionary{
        set{
            UIView.setAnimationsEnabled(false)

            super.properties = newValue

            let values = newValue.swiftDictionary
            if let p = values["text"]?.stringValue { text = p }

            if let p = values["titleColor"]?.colorValue { textColor = p }

            if let p = values["fontSize"]?.cgFloatValue{
                font = font.withSize(p)
            }

            if let p = values["boldFont"]?.boolValue {
                if p {
                    font = font.bold
                }else{
                    font = font.normal
                }
            }

            if let p = values["textAlignment"]?.segmentItemValue {
                textAlignment = NSTextAlignment(rawValue: p.selectedItem) ?? .center
            }

            if let p = values["tintColor"]?.colorValue {
                tintColor = p
            }

            UIView.setAnimationsEnabled(true)

        }get{
            let values:[String : IBProperty] = ["text": .text(text),
                                                "titleColor" : .color(textColor),
                                                "fontSize" : .cgfloat(font.pointSize),
                                                "boldFont": .boolean(font.isBold),
                                                "textAlignment" : .enumeration(SegmentDataItem(selectedItem: selectedAlighmentAsInt, options: ["Left","Center","Right"]))]

            return NSDictionary(dictionary: values.merging(super.properties.swiftDictionary, uniquingKeysWith: { $1 }))
        }
    }

    var selectedAlighmentAsInt: Int {
        switch textAlignment {

        case .left:
            return 0
        case .center:
            return 1
        case .right:
            return 2
        default:
            return 1
        }
    }
}

extension UIFont {

    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: pointSize)
    }

    var normal: UIFont {
        return withTraits(traits: [])
    }

    var bold: UIFont {
        return withTraits(traits: .traitBold)
    }

    var italic: UIFont {
        return withTraits(traits: .traitItalic)
    }

    var boldItalic: UIFont {
        return withTraits(traits: .traitBold, .traitItalic)
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}
