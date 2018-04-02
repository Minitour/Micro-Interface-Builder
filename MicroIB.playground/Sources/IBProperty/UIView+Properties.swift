//
//  UIView+Properties.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 22/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    @objc
    public func setProperty(key: String, value: IBProperty){
        var prop = properties.swiftDictionary
        prop[key] = value
        properties = NSDictionary(dictionary: prop)
    }

    @objc
    public var properties: NSDictionary{
        set{
            let values = newValue.swiftDictionary

            if let p = values["alpha"]?.floatValue { alpha = CGFloat(p) }

            if let p = values["backgroundColor"]?.colorValue { backgroundColor = p }

            if let p = values["cornerRadius"]?.floatValue { layer.cornerRadius = (CGFloat(p) * frame.height/2.0) }

            if let p = values["masksToBounds"]?.boolValue { layer.masksToBounds = p }

            if let p = values["locked"]?.boolValue { locked = p }

        }get{
            let values:[String : IBProperty] = [
                "alpha" : .precent(Float(alpha)),
                "backgroundColor": .color(backgroundColor),
                "cornerRadius" : .precent(Float(layer.cornerRadius/frame.height) * 2.0),
                "masksToBounds" : .boolean(layer.masksToBounds),
                "autoresizingMask" : .autoResizingMask(autoresizingMask),
                "locked" : .boolean(locked)
            ]

            return NSDictionary(dictionary: values)
        }
    }

    fileprivate var locked: Bool {
        get{
            return (superview as? DraggableView)?.isLocked ?? false
        }set{
            (superview as? DraggableView)?.isLocked = newValue
        }
    }
}
