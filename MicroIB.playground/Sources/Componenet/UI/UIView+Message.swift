//
//  UIView+MessageView.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 29/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    public func showMessage(_ message: String,
                            forDuration duration: TimeInterval = 3.0,
                            withDelay delay: TimeInterval = 0.0,
                            showingIcon icon: UIImage? = nil){
        let action = { [weak self] in
            //remove message view if exists
            if let `self` = self {
                for v in self.subviews {
                    if v is UIButton, v.tag == 999 {
                        v.removeFromSuperview()
                    }
                }

                //setup label
                let label = UIButton()
                label.tag = 999
                label.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                label.setTitle(message, for: [])
                label.tintColor = .white
                label.isUserInteractionEnabled = false
                label.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8049383601)
                if let image = icon {
                    label.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
                    label.titleEdgeInsets.left = 8
                }
                label.sizeToFit()
                label.layer.cornerRadius = label.frame.height / 2.0
                label.layer.masksToBounds = true
                label.frame.size.width += 16.0

                //add to view
                label.alpha = 0.0
                self.addSubview(label)
                label.center = self.center
                UIView.animate(withDuration: 0.1) {
                    label.alpha = 1.0
                }

                //add timer to remove
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    UIView.animate(withDuration: 0.1, animations: {
                        label.alpha = 0.0
                    }, completion: { (comp) in
                        label.removeFromSuperview()
                    })
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            action()
        }

    }
}
