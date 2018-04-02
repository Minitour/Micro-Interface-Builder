//
//  DraggableItemCell.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 15/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class DraggableItemCell: UICollectionViewCell {
    lazy var imageView: UIImageView! = UIImageView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()

    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup(){
        backgroundColor = .white
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor,constant: 8.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8.0).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 8.0).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor,constant: -8.0).isActive = true
    }

    
}

extension UIView {

    func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
}
