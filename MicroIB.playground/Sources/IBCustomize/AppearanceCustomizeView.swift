//
//  AppearanceCustomizeView.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 23/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class AppearanceCustomizeView: UIView {

    open var onViewHeirarchyClicked: ((UIButton)->Void)?

    open weak var canvasView: CanvasView?

    open weak var draggableView: DraggableView?{
        didSet{
            collectionView.reloadData()

            [bringToFrontButton,
             sendToBackButton,
             deleteButton]
                .forEach { $0.isEnabled = self.draggableView != nil }
        }
    }

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TextPropertyCell.self, forCellWithReuseIdentifier: "TextPropertyCell")
        collectionView.register(ColorPropertyCell.self, forCellWithReuseIdentifier: "ColorPropertyCell")
        collectionView.register(ImagePropertyCell.self, forCellWithReuseIdentifier: "ImagePropertyCell")
        collectionView.register(PrecentPropertyCell.self, forCellWithReuseIdentifier: "PrecentPropertyCell")
        collectionView.register(BooleanPropertyCell.self, forCellWithReuseIdentifier: "BooleanPropertyCell")
        collectionView.register(EnumPropertyCell.self, forCellWithReuseIdentifier: "EnumPropertyCell")
        collectionView.register(ResizingMaskPropertyCell.self, forCellWithReuseIdentifier: "ResizingMaskPropertyCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EMPTY_CELL")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    fileprivate lazy var debugViewHeirarchy: UIButton = {
        let button = AZButton(type: .system)
        button.onClick = didTapLaunchDebugViewHeirarchy
        button.setTitle("3D Inspector", for: [])
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.6274509804, blue: 0.5215686275, alpha: 1)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        return button
    }()

    fileprivate lazy var bringToFrontButton: UIButton = {
        let button = AZButton(type: .system)
        button.onClick = {[weak self] button in
            if let `self` = self,let draggable = self.draggableView {
                draggable.canvasSuperview?.bringDraggble(toFront: draggable)
            }
        }
        button.setTitle("To Front", for: [])
        button.tintColor = #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0.8588235294, alpha: 1)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()

    fileprivate lazy var sendToBackButton: UIButton = {
        let button = AZButton(type: .system)
        button.onClick = {[weak self] button in
            if let `self` = self,let draggable = self.draggableView {
                draggable.canvasSuperview?.bringDraggable(toBack: draggable)
            }
        }
        button.setTitle("To Back", for: [])
        button.tintColor = #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0.8588235294, alpha: 1)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()

    fileprivate lazy var deleteButton: UIButton = {
        let button = AZButton(type: .system)
        button.setTitle("Delete", for: [])
        button.onClick = {[weak self] button in
            if let `self` = self,let draggable = self.draggableView {
                draggable.canvasSuperview?.removeDraggable(view: draggable)
            }
        }
        button.tintColor = .red
        button.backgroundColor = .white
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(){
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5

        backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9450980392, alpha: 1)

        let stackView = UIStackView()
        addSubview(stackView)

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8.0).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true


        let actionStack = UIStackView(arrangedSubviews: [debugViewHeirarchy,bringToFrontButton,sendToBackButton,deleteButton])
        actionStack.axis = .horizontal
        actionStack.distribution = .fillEqually
        actionStack.spacing = 4.0

        stackView.addArrangedSubview(actionStack)
        stackView.addArrangedSubview(collectionView)

        actionStack.translatesAutoresizingMaskIntoConstraints = false
        actionStack.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9).isActive = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.7).isActive = true
        collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0).isActive = true
    }

    fileprivate var props: [String : IBProperty]? {
        return draggableView?.contentView?.properties.swiftDictionary
    }

    fileprivate var numberOfProperties: Int {
        return props?.count ?? 0
    }

    fileprivate func propertyAtIndex(_ index: Int)-> String?{
        if let prop = props {
            return Array(prop.keys).sorted(by: { prop[$0]!.type < prop[$1]!.type} )[index]
        }

        return nil
    }

    func didTapLaunchDebugViewHeirarchy(sender: UIButton){
        onViewHeirarchyClicked?(sender)
    }

}

extension AppearanceCustomizeView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2.8
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

extension AppearanceCustomizeView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let val = numberOfProperties

        if val == 0 {
            if let canvas = canvasView {
                collectionView.setEmptyMessage(canvas.isEmpty ? "Hold and Drag a Componenet Into The Canvas" : "No Item Selected")
            }else {
                collectionView.setEmptyMessage("No Item Selected")
            }

        } else {
            collectionView.restore()
        }

        return val
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let key = propertyAtIndex(indexPath.item),let property = props?[key] {

            var fCell: UICollectionViewCell?

            switch property.type {
            case .text: fallthrough
            case .cgfloat: fallthrough
            case .float: fallthrough
            case .number:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextPropertyCell", for: indexPath) as? TextPropertyCell {
                    cell.draggable = draggableView
                    cell.property = property
                    cell.key = key
                    fCell = cell
                }
            case .color:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorPropertyCell", for: indexPath) as? ColorPropertyCell {
                    cell.draggable = draggableView
                    cell.property = property
                    cell.key = key
                    fCell = cell
                }
            case .image:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePropertyCell", for: indexPath) as? ImagePropertyCell {
                    cell.draggable = draggableView
                    cell.property = property
                    cell.key = key
                    fCell = cell
                }
            case .precent:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrecentPropertyCell", for: indexPath) as? PrecentPropertyCell {
                    cell.draggable = draggableView
                    cell.property = property
                    cell.key = key
                    fCell = cell
                }
            case .boolean:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BooleanPropertyCell", for: indexPath) as? BooleanPropertyCell {
                    cell.draggable = draggableView
                    cell.property = property
                    cell.key = key
                    fCell = cell
                }
            case .enumeration:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnumPropertyCell", for: indexPath) as? EnumPropertyCell {
                    cell.draggable = draggableView
                    cell.property = property
                    cell.key = key
                    fCell = cell
                }
            case .autoResizingMask:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResizingMaskPropertyCell", for: indexPath) as? ResizingMaskPropertyCell {
                    cell.draggable = draggableView
                    cell.property = property
                    cell.key = key
                    fCell = cell
                }
            default:
                fatalError()
            }

            if let cell = fCell{
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 5.0
                cell.layer.masksToBounds = true
                return cell
            }
            fatalError("Could not init cell")
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "EMPTY_CELL", for: indexPath)
    }
}

public extension UIView {
    public func clone<T: UIView>()-> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }

    public func cloneAsImage()-> UIView {
        let imageView = UIImageView(image: asImage()!)
        imageView.frame = self.frame
        return imageView
    }
}

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}








