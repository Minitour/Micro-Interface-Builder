//
//  ComponentMenu.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 15/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class ComponentMenu: UIView{

    var collectionView: UICollectionView!
    var componentDataSource: ComponentDataSource!

    fileprivate let spacing: CGFloat = 4.0

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup(){

        backgroundColor = #colorLiteral(red: 0.9078931052, green: 0.9078931052, blue: 0.9078931052, alpha: 1)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2.0
        layout.minimumLineSpacing = 2.0
        layout.itemSize = CGSize(width: 50.0, height: 50.0)

        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(DraggableItemCell.self, forCellWithReuseIdentifier: "cell")

        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [collectionView.topAnchor.constraint(equalTo: topAnchor),
             collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
             collectionView.leftAnchor.constraint(equalTo: leftAnchor),
             collectionView.rightAnchor.constraint(equalTo: rightAnchor)]
        )

        componentDataSource = ComponentDataSource.init()
        collectionView.dragInteractionEnabled = true
        collectionView.dataSource = componentDataSource
        collectionView.delegate = self

        collectionView.dragDelegate = self

        //collectionView.collectionViewLayout.scrollDirection = .horizontal
    }
}

extension ComponentMenu: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 6.5 - 2.0
        let height = collectionView.frame.height - spacing * 2
        return CGSize(width: width, height: height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        superview?.showMessage("Hold and Drag the view into the Canvas")
    }
}

extension ComponentMenu: UICollectionViewDragDelegate {



    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let image = ComponentDataSource.items[indexPath.item].computedImage
        let itemProvider = NSItemProvider(object: "\(indexPath.item)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.previewProvider = {
            let imageView = UIImageView(image: image)
            imageView.backgroundColor = .clear

            let dp =  UIDragPreview(view: imageView)
            return dp
        }
        return [dragItem]
    }

    public func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let previewParameters = UIDragPreviewParameters()
        previewParameters.backgroundColor = UIColor.clear
        return previewParameters
    }
}
