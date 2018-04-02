//
//  IBInspectableCell.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 24/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class IBInspectableCell: UICollectionViewCell {
    open lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    open weak var draggable: DraggableView?

    open var property: IBProperty?

    internal var stackView: UIStackView!

    open var key: String? {
        didSet{
            titleLabel.text = key?.camelCaseToTitleCase
            if let key = key {
                property = draggable?.contentView?.properties.swiftDictionary[key]
                if let prop = property {
                    didUpdateKey(withProperty: prop)
                }
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(){
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 8.0
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor,constant: 8.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8.0).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor,constant: 8.0).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor,constant: -8.0).isActive = true
        stackView.addArrangedSubview(titleLabel)
        didFinishSetup()
    }

    internal func didFinishSetup(){}

    internal func didUpdateKey(withProperty property: IBProperty){}
}
