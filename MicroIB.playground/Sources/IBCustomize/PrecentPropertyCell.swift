//
//  PrecentPropertyCell.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 24/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit


public class PrecentPropertyCell: IBInspectableCell {

    fileprivate lazy var slider: UISlider = {
        let slider = AZSlider()
        slider.onValueChanged = valueDidChange(_:)
        return slider
    }()

    override func didUpdateKey(withProperty property: IBProperty) {
        slider.value = property.floatValue ?? 0.0
    }

    override func didFinishSetup() {
        stackView.addArrangedSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }

    func valueDidChange(_ sender: UISlider){
        if let prop = self.property, let key = self.key {
            prop.value = sender.value
            self.draggable?.contentView?.setProperty(key: key, value: prop)
        }
    }

}

