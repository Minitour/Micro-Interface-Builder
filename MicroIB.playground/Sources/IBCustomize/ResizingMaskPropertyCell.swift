//
//  ResizingMaskPropertyCell.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 26/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

class ResizingMaskPropertyCell: IBInspectableCell {

    fileprivate lazy var autoResizingMaskView: AutoResizingMaskSelectorView = {
       let view = AutoResizingMaskSelectorView()
        view.onMaskChanged = onMaskChanged(_:)
        return view
    }()

    override func didUpdateKey(withProperty property: IBProperty) {
        if let masks = draggable?.autoresizingMask {
            autoResizingMaskView.selectedMask = masks
        }
    }

    override func didFinishSetup() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(autoResizingMaskView)
        autoResizingMaskView.translatesAutoresizingMaskIntoConstraints = false
        autoResizingMaskView.widthAnchor.constraint(equalTo: autoResizingMaskView.heightAnchor, multiplier: 1.5).isActive = true
        //autoResizingMaskView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.8).isActive = true

    }

    func onMaskChanged(_ mask: UIViewAutoresizing){
        draggable?.autoresizingMask = autoResizingMaskView.selectedMask 
    }

}
