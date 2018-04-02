//
//  CreateConstraintView.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 21/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public class CreateConstraintView: UIView {

    open weak var object: DraggableView?

    //title/message label
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()

    //collection view to hold the views on which we are constrainting to.
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.register(ConstraintSelectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        return collectionView
    }()

    fileprivate lazy var associationSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["item 1","item 2"])
        segment.selectedSegmentIndex = 0
        return segment
    }()

    fileprivate lazy var associationConstantField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        return textfield
    }()

    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8.0
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        return stackView
    }()

    fileprivate var type: ConstraintType? = nil


    init(type: ConstraintType){
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 150, height: 250))
        self.type = type
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup(){
        if let type = type {

            //add title
            label.text = "Title"
            stackView.addArrangedSubview(label)

            switch type {
            case .verticalAnchor:
                setupVerticalAnchor()
            case .horiztonalAnchor:
                setupHorizontalAnchor()
            case .alignment:
                setupAlignment()
            case .size(let isConstant):
                setupSize(isConstant: isConstant)
            }

        }
    }

    func setupVerticalAnchor(){
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(associationSegment)
        stackView.addArrangedSubview(associationConstantField)
    }

    func setupHorizontalAnchor(){
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(associationSegment)
        stackView.addArrangedSubview(associationConstantField)
    }

    func setupAlignment(){
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(associationConstantField)
    }

    func setupSize(isConstant: Bool){
        if !isConstant {
            stackView.addArrangedSubview(collectionView)
            stackView.addArrangedSubview(associationSegment)
        }else{

        }
        stackView.addArrangedSubview(associationConstantField)
    }

    public enum ConstraintType {
        case verticalAnchor
        case horiztonalAnchor
        case alignment
        case size(Bool)
    }
}

class ConstraintSelectionViewCell: UICollectionViewCell {
    fileprivate var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(){
        imageView = UIImageView()
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor,constant: 8.0).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 8.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8.0).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor,constant: -8.0).isActive = true

    }

    override var isSelected: Bool{
        get{
            return super.isSelected
        }set{
            backgroundColor = newValue ? .blue : .white
            super.isSelected = newValue
        }
    }
}

extension CreateConstraintView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        return CGSize(width: height, height: height)
    }
}

extension CreateConstraintView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }
}
