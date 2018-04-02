//
//  EnumPropertyCell.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 24/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class EnumPropertyCell: IBInspectableCell {

    fileprivate lazy var segmentControl: UISegmentedControl = {
        let segment = AZSegmentControl(frame: .zero)
        segment.onValueChanged = valueDidChange(_:)
        return segment
    }()

    override func didFinishSetup() {
        stackView.addArrangedSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }

    override func didUpdateKey(withProperty property: IBProperty) {
        if let si = property.segmentItemValue {
            segmentControl.removeAllSegments()
            for i in 0..<si.options.count {
                segmentControl.insertSegment(withTitle: si.options[i], at: i, animated: false)
            }
            segmentControl.selectedSegmentIndex = si.selectedItem < si.options.count ? si.selectedItem : 0
        }
    }

    func valueDidChange(_ sender: UISegmentedControl){
        if let prop = self.property, let key = self.key {
            prop.value = SegmentDataItem(selectedItem: sender.selectedSegmentIndex, options: [])
            self.draggable?.contentView?.setProperty(key: key, value: prop)
        }
    }

}
