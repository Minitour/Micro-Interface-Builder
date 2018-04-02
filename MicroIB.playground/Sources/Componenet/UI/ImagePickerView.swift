//
//  ImagePickerView.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 22/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit
import Photos

public class ImagePickerView: UIView {

    let isPlayground = Bundle.allBundles.contains(where: { ($0.bundleIdentifier ?? "").hasPrefix("com.apple.dt.") })

    //used in Xcode playground
    var photos: [UIImage?]!

    //used anywhere else
    var assetsPhotos: PHFetchResult<PHAsset>!

    var onImageSelected: ((UIImage?)->Void)?

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 5.0
        collectionView.layer.masksToBounds = true
        return collectionView
    }()

    fileprivate lazy var errorLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    fileprivate lazy var cancelButotn: UIButton = {
        let button = AZButton(type: .system)
        button.setTitle("Cancel", for: [])
        button.onClick = {[weak self] btn in
            self?.onImageSelected?(nil)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(){

        let stackView = UIStackView(arrangedSubviews: [collectionView,cancelButotn])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.spacing = 8.0

        if isPlayground {
            //in xcode playground
            photos = [#imageLiteral(resourceName: "IMG_0001.JPG"),#imageLiteral(resourceName: "IMG_0002.JPG"),#imageLiteral(resourceName: "IMG_0003.JPG"),#imageLiteral(resourceName: "IMG_0004.JPG"),#imageLiteral(resourceName: "IMG_0005.JPG")]
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
        } else {
            //not in playground
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status
                {
                case .authorized:
                    let fetchOptions = PHFetchOptions()
                    DispatchQueue.main.async {
                        //self.photos = [UIImage?]()

                        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                        self.assetsPhotos = assets
                        self.collectionView.delegate = self
                        self.collectionView.dataSource = self
                        self.collectionView.reloadData()
                    }
                case .denied, .restricted, .notDetermined:
                    DispatchQueue.main.async {
                        self.collectionView.removeFromSuperview()
                        self.errorLabel.text = "Something went wrong 😕"
                        stackView.insertArrangedSubview(self.errorLabel, at: 0)
                    }
                }
            }
        }

    }
}

extension ImagePickerView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.height
        return CGSize(width: width, height: width)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if isPlayground {
            if let photos = photos,let image = photos[indexPath.item] {
                onImageSelected?(image)
            }
        }
        else{
            if let photos = assetsPhotos {
                photos[indexPath.item].image() { [weak self] img in
                    self?.onImageSelected?(img)
                }
            }
        }

    }
}

extension ImagePickerView: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isPlayground ? photos.count : assetsPhotos.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageCell{
            if isPlayground {
                cell.imageView.image = photos[indexPath.item]
            }else{
                assetsPhotos[indexPath.item].thumbnail { img in
                    cell.imageView.image = img
                }
            }
            return cell
        }
        fatalError()
    }
}

extension PHAsset {
    public func image(_ callback: ((UIImage?)->Void)?) {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.deliveryMode = .fastFormat
        options.isSynchronous = true
        manager.requestImageData(for: self, options: options) { data, _, _, _ in

            if let data = data {
                img = UIImage(data: data)
                OperationQueue.main.addOperation  {
                    callback?(img)
                }
            }
        }
    }

    public func thumbnail(_ callback: ((UIImage?)->Void)?) {
        PHImageManager.default().requestImage(for: self, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
            callback?(image)
        }
    }
}

fileprivate class ImageCell: UICollectionViewCell {
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
        imageView.contentMode = .scaleToFill
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
