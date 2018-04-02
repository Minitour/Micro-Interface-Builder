//
//  ColorPropertyCell.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 24/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit


public class ColorPropertyCell: IBInspectableCell {

    fileprivate lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.3
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapColorView))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    override func didUpdateKey(withProperty property: IBProperty) {
        colorView.backgroundColor = property.colorValue ?? .clear
    }

    override func didFinishSetup() {
        stackView.addArrangedSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        colorView.widthAnchor.constraint(equalTo: colorView.heightAnchor, multiplier: 1.0).isActive = true
    }

    @objc
    func didTapColorView(){
        let colorPicker = ColorPicker(frame: CGRect(origin: .zero, size: CGSize(width: frame.width, height: 100)))
        colorPicker.selectedColor(sColor: colorView.backgroundColor ?? .clear)

        if let superview = superview?.superview?.superview?.superview {
            let popup = PopUpView.show(in: superview, from: colorView,using: colorPicker,direction: .top)

            colorPicker.onColorSelected = { color in
                popup.dismiss()
            }

            colorPicker.onColorChanged = {[weak self] color in
                if let `self` = self {
                    self.colorView.backgroundColor = color
                    if let prop = self.property, let key = self.key {
                        prop.value = color
                        self.draggable?.contentView?.setProperty(key: key, value: prop)
                    }
                }
            }
        }
    }
}

