//
//  ImagePropertyCell.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 24/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class ImagePropertyCell: IBInspectableCell {

    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.3
        view.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    override func didUpdateKey(withProperty property: IBProperty) {
        imageView.image = property.imageValue
    }

    override func didFinishSetup() {
        stackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
    }

    func updateImage(_ image: UIImage?){
        self.imageView.image = image
        if let prop = self.property, let key = self.key {
            prop.value = image
            self.draggable?.contentView?.setProperty(key: key, value: prop)
        }
    }

    @objc
    func didTapImageView(){
        let imagePicker = ImagePickerView(frame: CGRect(origin: .zero, size: CGSize(width: frame.width, height: 100.0)))

        if let superview = superview?.superview?.superview?.superview {
            let popup = PopUpView.show(in: superview, from: imageView,using: imagePicker,direction: .top)

            imagePicker.onImageSelected =  { [weak self] image in
                self?.updateImage(image)
                popup.dismiss()
            }
        }
    }
}
