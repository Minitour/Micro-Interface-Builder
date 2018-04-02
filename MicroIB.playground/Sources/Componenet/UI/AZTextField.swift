//
//  AZTextField.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 22/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class AZTextField: UITextField {

    open var onTextChanged: ((UITextField) -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(){
        autocorrectionType = .no
        inputAssistantItem.leadingBarButtonGroups = []
        inputAssistantItem.trailingBarButtonGroups = []
        addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
        let isPlayground = Bundle.allBundles.contains(where: { ($0.bundleIdentifier ?? "").hasPrefix("com.apple.dt.") })

        let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 600.0, height: isPlayground ? 300.0 : 200.0))
        let view = KeyboardView(inputField: self)

        container.addSubview(view)
        if isPlayground {
            //in xcode playground so setup custom keyboard
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.62).isActive = true
            view.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.78).isActive = true
            view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
            inputView = container
        }



        view.didChangeText = didChangeText

    }

    @objc func didChangeText(_ sender: UITextField){
        onTextChanged?(self)
    }
}
