//
//  BooleanPropertyCell.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 24/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class BooleanPropertyCell: IBInspectableCell {

    fileprivate lazy var checkbox: UISwitch = {
        let checkbox = AZSwitch()
        checkbox.onValueChanged = valueDidChange
        return checkbox
    }()

    override func didUpdateKey(withProperty property: IBProperty) {
        checkbox.isOn = property.boolValue ?? false
    }

    override func didFinishSetup() {
        stackView.addArrangedSubview(checkbox)
    }

    func valueDidChange(_ sender: UISwitch){
        if let prop = self.property, let key = self.key {
            prop.value = sender.isOn
            self.draggable?.contentView?.setProperty(key: key, value: prop)
        }
    }
}
