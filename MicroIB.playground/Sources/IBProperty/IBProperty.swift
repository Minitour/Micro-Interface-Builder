//
//  IBProperty.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 22/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

@objc
public class IBProperty: NSObject {

    public var value: Any?

    public var type: IBType = .other

    public init(value: Any?,type: IBType) {
        self.value = value
        self.type = type
    }

    public override var description: String {
        return "\(value ?? "nil")"
    }

    open var stringValue: String? {
        return value as? String
    }

    open var intValue: Int? {
        return value as? Int
    }

    open var floatValue: Float? {
        return value as? Float
    }

    open var cgFloatValue: CGFloat? {
        return value as? CGFloat
    }

    open var imageValue: UIImage? {
        return value as? UIImage
    }

    open var colorValue: UIColor? {
        return value as? UIColor
    }

    open var boolValue: Bool? {
        return value as? Bool
    }

    open var segmentItemValue: SegmentDataItem? {
        return value as? SegmentDataItem
    }

    open var autoResizingMaskValue: UIViewAutoresizing? {
        return value as? UIViewAutoresizing
    }

    open class func autoResizingMask(_ mask: UIViewAutoresizing)-> IBProperty {
        return IBProperty(value: mask, type: .autoResizingMask)
    }

    open class func text(_ text: String?) -> IBProperty {
        return IBProperty(value: text,type: .text)
    }

    open class func number(_ number: Int) -> IBProperty {
        return IBProperty(value: number,type: .number)
    }

    open class func cgfloat(_ float: CGFloat) -> IBProperty {
        return IBProperty(value: float,type: .cgfloat)
    }

    open class func color(_ color: UIColor?) -> IBProperty {
        return IBProperty(value: color,type: .color)
    }

    open class func image(_ image: UIImage?) -> IBProperty {
        return IBProperty(value: image,type: .image)
    }

    open class func precent(_ precent: Float) -> IBProperty {
        return IBProperty(value: precent,type: .precent)
    }

    open class func boolean(_ boolean: Bool) -> IBProperty {
        return IBProperty(value: boolean,type: .boolean)
    }

    open class func enumeration(_ enumeration: SegmentDataItem) -> IBProperty {
        return IBProperty(value: enumeration,type: .enumeration)
    }
}
