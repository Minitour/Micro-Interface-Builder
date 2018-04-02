//
//  Extensions.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 23/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation

public extension Dictionary {
    static public func + <K, V>(left: [K:V], right: [K:V]) -> [K:V] {
        return left.merging(right) { $1 }
    }
}


public extension NSDictionary {
    var swiftDictionary: Dictionary<String, IBProperty> {
        var swiftDictionary = Dictionary<String, IBProperty>()

        for key : Any in self.allKeys {
            let stringKey = key as! String
            if let keyValue = self.value(forKey: stringKey) as? IBProperty{
                swiftDictionary[stringKey] = keyValue
            }
        }

        return swiftDictionary
    }
}



public extension String {
    public var camelCaseToTitleCase: String {
        let stringCharacters = Array(self).map{ String($0) }
        let str = stringCharacters.flatMap{ $0.lowercased() != $0 ? " " + $0 : $0 }.joined(separator: "")
        let first = String(str.prefix(1)).capitalized
        let other = String(str.dropFirst())
        return first + other
    }
}
