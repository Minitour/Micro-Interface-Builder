//
//  AZSlider.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 24/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class AZSlider: UISlider{

    open var  onValueChanged: ((UISlider)->Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(){
        addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
    }

    @objc func didChangeValue(_ sender: UISlider){
        onValueChanged?(self)
    }
}
