//
//  IBHeirarchyView.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 27/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit
import SceneKit

public class IBHeirarchyView: SCNView {

    open var onDismissClicked: (()->Void)?

    //zoom levels
    let zooms:[CGFloat] = [0.25,
                           0.5,
                           0.75,
                           1.0,
                           1.25,
                           1.5,
                           2.0,
                           3.0]

    let cameraNode = SCNNode()

    fileprivate lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.backgroundColor = .white
        stepper.layer.cornerRadius = 3.0
        stepper.layer.masksToBounds = true

        return stepper
    }()

    fileprivate lazy var closeButton: UIButton = {
        let button = AZButton(type: .system)
        button.setTitle("Close Inspector", for: [])
        button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        button.onClick = {[weak self] button in
            self?.onDismissClicked?()
        }
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2007239106)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        setup()
    }

    var originalPosition: Float = 0.0
    public func set(view: UIView?) {

        scene?.rootNode.childNodes.forEach { $0.removeFromParentNode() }

        if let view = view {
            let zPos = Float(view.bounds.height / 20.0) * sqrt(3.0)
            originalPosition = zPos
            cameraNode.position = SCNVector3(x: 0, y: 0, z: zPos + 1.0)
            scene?.layoutViewInScene(view: view,space: 1.5,superview: view)
        }
    }



    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(){
        //init scene
        scene = SCNScene()

        allowsCameraControl = true
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true

        //setup camera
//        cameraNode.camera = SCNCamera()
//        cameraNode.camera?.fieldOfView = 60.0
//        cameraNode.camera?.usesOrthographicProjection = true
//        pointOfView = cameraNode

        // configure the view
        backgroundColor = UIColor.lightGray

        antialiasingMode = .multisampling4X

        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)

        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        //closeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8.0).isActive = true
        closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8.0).isActive = true

    }

    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView

        // check what nodes are tapped
        let p = gestureRecognize.location(in: self)
        let hitResults = hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]

            // get its material
            let material = result.node.geometry!.firstMaterial!

            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5

            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5

                material.emission.contents = UIColor.black

                SCNTransaction.commit()
            }

            material.emission.contents = UIColor.blue

            SCNTransaction.commit()
        }
    }
}

extension SCNScene {


    /// Inserts a UIView into a scene.
    ///
    /// - Parameters:
    ///   - view: The current he view
    ///   - zValue: the z position of the node (do not set)
    ///   - space: The space between each node on the z axis
    ///   - superview: The root view.
    func layoutViewInScene(view: UIView?,zValue: Float = 0.0,space: Float = 1.0,superview: UIView){
        if let view = view {
            //layout view
            let node = view.asNode!
            let center = view.convert(view.bounds, to: superview)

            node.position = SCNVector3(x: Float(center.midX - superview.bounds.width / 2.0) / 10.0,
                                       y: -Float(center.midY - superview.bounds.height / 2.0) / 10.0, z: zValue)
            self.rootNode.addChildNode(node)

            var subSpacer: Float = 0.0
            for sub in view.subviews {
                layoutViewInScene(view: sub,zValue: zValue + space + subSpacer,space: space,superview: superview)
                subSpacer += 1.0
            }
        }
    }
}

fileprivate extension UIView {

    var asNode: SCNNode? {
        let planeGeo = SCNPlane(width: bounds.width / 10.0, height: bounds.height / 10.0)
        let imageMaterial = SCNMaterial()
        imageMaterial.diffuse.contents = renderedImage
        imageMaterial.isDoubleSided = true
        planeGeo.firstMaterial = imageMaterial
        let plane = SCNNode(geometry: planeGeo)
        return plane
    }

    fileprivate var renderedImage: UIImage? {
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 0.5
        for view in subviews {
            view.isHidden = true
        }
        defer {
            layer.borderColor = UIColor.clear.cgColor
            for view in subviews {
                view.isHidden = false
            }
        }
        UIGraphicsBeginImageContextWithOptions((self.bounds.size), false, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
        }


        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return finalImage
    }
}
