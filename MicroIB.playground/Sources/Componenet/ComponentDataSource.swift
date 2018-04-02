//
//  ComponentDataSource.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 15/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public enum ResizeType {
    case width, height, both, none
}

public struct ComponentItem {
    var image: UIImage
    var size: CGSize
    var resize: ResizeType
    var inseration: ((UIView,UIView?) -> Void)? = nil
    var closure: (() -> UIView)?


    var computedImage: UIImage?{
        return closure?().asImage()
    }

    var view: UIView? {
        return closure?()
    }
}

public class ComponentDataSource: NSObject, UICollectionViewDataSource {

    public static let containers: [UIView.Type] = [UIView.self,UIStackView.self]

    public static func isContainer(type: UIView.Type) -> Bool{
        for t in containers {
            if t == type{
                return true
            }
        }
        return false
    }

    static let color = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)

    public static let items = [
        //UILabel
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_label"),size: CGSize(width: 100, height: 49),resize: .both,inseration: nil) {
            let label = UILabel()
            label.text = "Label"
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 0, width: 100, height: 49)
            return label
        },

        //UIButton
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_button"),size: CGSize(width: 100, height: 46),resize: .both,inseration: nil) {
            let button = UIButton(type: .system)
            button.setTitle("Button", for: [])
            button.tintColor = ComponentDataSource.color
            button.frame = CGRect(x: 0, y: 60, width: 100, height: 46)
            return button
        },

        //UISegmentedControl
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_segment"),size: CGSize(width: 120, height: 40),resize: .width,inseration: nil) {
            let segment = UISegmentedControl(items: ["First","Second"])
            segment.frame = CGRect(x: 0, y: 0, width: 124, height: 40)
            segment.selectedSegmentIndex = 0
            segment.tintColor = ComponentDataSource.color
            return segment
        },

        //UIStepper
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_stepper"),size: CGSize(width: 109, height: 43),resize: .none,inseration: nil) {
            let stepper = UIStepper()
            stepper.tintColor = ComponentDataSource.color
            return stepper
        },

        //UITextField
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_textfield"),size: CGSize(width: 120, height: 43),resize: .width,inseration: nil) {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.text = ""
            textField.frame = CGRect(x: 0, y: 0, width: 100, height: 43)
            return textField
        },

        //UISlider
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_slider"),size: CGSize(width: 120, height: 50),resize: .width,inseration: nil) {
            let slider = UISlider()
            slider.value = 0.5
            slider.frame = CGRect(x: 0, y: 0, width: 124, height: 40)
            slider.tintColor = ComponentDataSource.color
            return slider
        },

        //UISwitch
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_switch"),size: CGSize(width:65, height: 45.5),resize: .none,inseration: nil) {
            let swtch = UISwitch()
            swtch.isOn = true
            return swtch
        },//#imageLiteral(resourceName: "ic_comp_pager")

        //UIPageControl
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_pager"),size: CGSize(width: 80, height: 40),resize: .width,inseration: nil) {
            let pager = UIPageControl()
            pager.currentPage = 0
            pager.numberOfPages = 3
            pager.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
            return pager
        },

        //UIActivityIndicatorView
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_activity"),size: CGSize(width: 49, height: 49),resize: .none,inseration: nil) {
            let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            view.hidesWhenStopped = false
            view.alpha = 1.0
            view.frame = CGRect(x: 0, y: 0, width: 49, height: 49)
            return view
        },

        //UIView
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_view"),size: CGSize(width: 200, height: 100),resize: .both, inseration: { superview, view in
            if let view = view {
                superview.addSubview(view)
            }
        }) {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
            return view
        },

        //UIImageView
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_imageview"),size: CGSize(width: 120, height: 120),resize: .both, inseration: nil){
            let image = UIImageView()
            image.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            image.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            return image
        },

        //UINavigationBar
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_nav"),size: CGSize(width: 240, height: 60),resize: .width, inseration: nil){
            let bar = UINavigationBar()
            let navigationItem = UINavigationItem(title: "Title")
            bar.setItems([navigationItem], animated: false)
            bar.frame = CGRect(x: 0, y: 0, width: 240, height: 60)
            return bar
        },

        //UITextView
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_textview"),size: CGSize(width: 240, height: 150),resize: .both,inseration: nil){
            let textview = UITextView()
            textview.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            textview.frame = CGRect(x: 0, y: 0, width: 240, height: 150)
            return textview
        },

        //UIBlurEffect
        ComponentItem(image: #imageLiteral(resourceName: "ic_comp_visualblur"),size: CGSize(width: 100, height: 100),resize: .both,inseration: nil) {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            return blurEffectView
        }
    ]

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ComponentDataSource.items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DraggableItemCell {
            cell.imageView.image = ComponentDataSource.items[indexPath.item].image
            return cell
        }
        fatalError("Could not dequeue cell.")
    }
}

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}


