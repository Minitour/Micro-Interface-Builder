//
//  IBType.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 22/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

@objc
public enum IBType: Int, Comparable{
    public static func <(lhs: IBType, rhs: IBType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    ///String value
    case text

    ///Int value
    case number

    ///Float value
    case float

    ///CGFloat
    case cgfloat

    ///UIColor value
    case color

    ///UIImage Value
    case image

    ///Float value between 0.0 and 1.0
    case precent

    /// true / false
    case boolean

    /// any enum that extends Int
    case enumeration

    /// Other value
    case other

    case autoResizingMask
}

public struct SegmentDataItem {
    var selectedItem: Int
    var options: [String]
}

