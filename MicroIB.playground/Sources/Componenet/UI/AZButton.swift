//
//  AZButton.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 22/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit


class AZButton: UIButton {
    open var onClick: ((UIButton)-> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(){
        addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
    }

    @objc func click(_ sender: UIButton) {
        onClick?(sender)
    }

    override var isHighlighted: Bool{
        set{
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.alpha = newValue ? 0.5 : 1
                self?.transform = newValue ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            }
            super.isHighlighted = newValue
        }get{
            return super.isHighlighted
        }
    }
}
