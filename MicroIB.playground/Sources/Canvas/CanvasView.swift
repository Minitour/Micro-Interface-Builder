//
//  CanvasView.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 15/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class CanvasView: UIView, ResizableViewDelegate {

    open fileprivate(set) var draggableViews: [Int : DraggableView] = [:]
    fileprivate(set) open var focusId: Int? = nil{
        didSet{
            focusChanged?(self)
        }
    }

    fileprivate lazy var generator: UIImpactFeedbackGenerator = {
        let gen =  UIImpactFeedbackGenerator(style: .medium)
        return gen
    }()

    open var isEmpty: Bool {
        return draggableViews.count == 0
    }

    open var focusChanged: ((CanvasView)->Void)?

    public weak var scrollView: UIScrollView?


    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(){

        //self.layer.masksToBounds = true
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5

        let dropInteraction = UIDropInteraction(delegate: self)
        addInteraction(dropInteraction)

        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        //addGestureRecognizer(tapGesture)

        addGuideLines()
    }

    fileprivate func addGuideLines(){
        let top = UIView()
        addSubview(top)
        top.translatesAutoresizingMaskIntoConstraints = false
        top.topAnchor.constraint(equalTo: topAnchor,constant: 20.0).isActive = true
        top.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        top.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        top.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        let bottom = UIView()
        addSubview(bottom)
        bottom.translatesAutoresizingMaskIntoConstraints = false
        bottom.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -20.0).isActive = true
        bottom.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        bottom.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottom.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        let left = UIView()
        addSubview(left)
        left.translatesAutoresizingMaskIntoConstraints = false
        left.topAnchor.constraint(equalTo: topAnchor).isActive = true
        left.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        left.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        left.leftAnchor.constraint(equalTo: leftAnchor,constant: 20.0).isActive = true

        let right = UIView()
        addSubview(right)
        right.translatesAutoresizingMaskIntoConstraints = false
        right.topAnchor.constraint(equalTo: topAnchor).isActive = true
        right.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        right.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        right.rightAnchor.constraint(equalTo: rightAnchor,constant: -20.0).isActive = true

        let centerX = UIView()
        addSubview(centerX)
        centerX.translatesAutoresizingMaskIntoConstraints = false
        centerX.topAnchor.constraint(equalTo: topAnchor).isActive = true
        centerX.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        centerX.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        centerX.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        let centerY = UIView()
        addSubview(centerY)
        centerY.translatesAutoresizingMaskIntoConstraints = false
        centerY.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        centerY.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        centerY.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        centerY.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true


    }

    public func  addDraggableView(view: DraggableView){
        view.delegate = self
        draggableViews[view.id] = view
        addSubview(view)
        focusId = view.id
        clearSelection()
    }

    public func bringDraggble(toFront: DraggableView){
        toFront.superview?.bringSubview(toFront: toFront)
    }
    public func bringDraggable(toBack: DraggableView){
        toBack.superview?.sendSubview(toBack: toBack)
    }

    public func free(_ view: DraggableView){
        self.draggableViews[view.id] = nil
        if view.isContainer {
            //remove subviews if exist
            for sub in view.draggableSubs(){
                free(sub)
            }
        }
    }

    public func removeDraggable(view: DraggableView,animated: Bool = true){

        let actions = {
            if let focus = self.focusId, view.id == focus {
                self.focusId = nil
            }

            self.free(view)
            view.removeFromSuperview()
        }

        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }) { (comple) in
                actions()
            }
        }else{
            actions()
        }

    }

    public func userResizableViewDidBeginEditing(_ userResizableView: DraggableView) {
        scrollView?.isScrollEnabled = false
        focusId = userResizableView.id
        clearSelection()
        generator.prepare()
        generator.impactOccurred()
    }

    func clearSelection(){
        for draggable in draggableViews.values {
            draggable.isSelected = draggable.id == focusId
        }
    }



    public func userResizableViewDidEndEditing(_ userResizableView: DraggableView) {
        scrollView?.isScrollEnabled = true
        unhighlight()
        //if view is subview, and view.center is outside of bounds
        //remove from view
        if subviews.contains(userResizableView), !bounds.contains(userResizableView.center){
            self.removeDraggable(view: userResizableView)
        }else{
            generator.prepare()
            generator.impactOccurred()
        }
    }

    public func userResizableViewDidDrag(_ userResizableView: DraggableView) {

    }

    public func userResizableViewExtractView(_ userResizableView: DraggableView, viewToExtract: DraggableView) {
        let point = userResizableView.convert(viewToExtract.center, to: self)
        viewToExtract.removeFromSuperview()

        //a flag indicating if the view we extracted has been moved to another container
        var didMove = false

        for draggableView in draggableViews.values {
            let key = draggableView.id
            if key != viewToExtract.id,key != userResizableView.id, draggableView.isContainer {
                if draggableView.frame.contains(point) {
                    draggableView.addSubViewToContainer(view: viewToExtract)
                    viewToExtract.center = self.convert(point, to: draggableView)
                    didMove = true
                }
            }
        }

        if !didMove {
            addSubview(viewToExtract)
            viewToExtract.center = point
            userResizableViewDidEndEditing(viewToExtract)
        }
    }


    @objc
    func didTapDraggable(sender: DraggableView){

    }

    @objc
    func didTapBackground(){
        resetAlpha()
    }

    fileprivate func resetAlpha(){
        draggableViews.forEach { (key,value) in
            value.alpha = 1.0
        }
    }

    fileprivate func unhighlight() {
        draggableViews.forEach { (key,value) in
            value.isHighlighted = false
        }
    }

    fileprivate func prepareDraggableView(forIndex index: Int)-> DraggableView {
        let item = ComponentDataSource.items[index]
        let view = item.view!
        let draggableView = DraggableView(frame: CGRect(origin: .zero, size: item.size))
        draggableView.contentView = view
        draggableView.inseration = item.inseration
        //draggableView.preventsPositionOutsideSuperview = true

        let height = item.resize == .both || item.resize == .height
        let width = item.resize == .both || item.resize == .width

        draggableView.resizeTop = height
        draggableView.resizeBottom = height
        draggableView.resizeLeft = width
        draggableView.resizeRight = width

        draggableView.isContainer = ComponentDataSource.isContainer(type: type(of: view))

        return draggableView
    }

    open var dummyView: UIView {
        let copy = clone()
        copy.subviews.forEach { $0.removeFromSuperview() }
        for sub in subviews {
            if sub is DraggableView {
                if let draggableSub = sub as? DraggableView,
                    let dummy = draggableSub.renderableDummy {
                    copy.addSubview(dummy)
                    dummy.frame = draggableSub.translatedFrame
                }
            }
        }
        return copy
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        for draggable in draggableViews.values {
            if draggable.frame.contains(touch.location(in: self)){
                return
            }
        }
        focusId = nil
        clearSelection()

    }
}

extension CanvasView: UIDropInteractionDelegate {
    public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSString.self) { [weak self] strings in
            let items = strings as! [NSString]
            let index = Int(items.first! as String)!

            if let `self` = self {
                let location = session.location(in: self)
                let draggableObject = self.prepareDraggableView(forIndex: index)
                self.addDraggableView(view: draggableObject)
                draggableObject.center = location
            }
        }
    }

    public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.items.count == 1
    }

    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
}

