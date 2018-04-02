//
//  DraggableFile.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 15/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
public class DraggableView: UIView {

    public var canvasSuperview: CanvasView? {

        var view: UIView = self

        while view.superview != nil {
            if view is CanvasView {
                return view as? CanvasView
            }
            view = view.superview!
        }

        return view as? CanvasView
    }

    fileprivate static var id_arc: Int = 0
    fileprivate class var autoId: Int {
        defer {
            id_arc += 1
        }
        return id_arc
    }

    open let id: Int

    open var isLocked = false

    open weak var delegate: ResizableViewDelegate?

    @IBInspectable
    open var resizeTop: Bool = true {
        didSet{
            updateBorderView()
        }
    }

    @IBInspectable
    open var resizeBottom: Bool = true {
        didSet{
            updateBorderView()
        }
    }

    @IBInspectable
    open var resizeLeft: Bool = true {
        didSet{
            updateBorderView()
        }
    }

    @IBInspectable
    open var resizeRight: Bool = true {
        didSet{
            updateBorderView()
        }
    }

    open var isSelected: Bool = false {
        didSet{
            borderView.alpha = !isSelected ? 0.0 : 1.0
        }
    }

    open var isHighlighted: Bool = false {
        didSet{
            if isHighlighted {
                insertSubview(highlightView,at: 0)
                highlightView.frame = CGRect(origin: .zero, size: self.frame.size)

            }else {
                highlightView.removeFromSuperview()
            }
        }
    }

    open var inseration: ((UIView,UIView?) -> Void)? = nil

    fileprivate func updateBorderView() {
        borderView.top = resizeTop
        borderView.bottom = resizeBottom
        borderView.right = resizeRight
        borderView.left = resizeLeft
        borderView?.setNeedsDisplay()
    }

    fileprivate var borderView: BorderView!
    fileprivate lazy var highlightView: UIView = {
        let view = UIView()
        view.backgroundColor  = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        return view
    }()
    fileprivate var _contentView: UIView?
    fileprivate var touchStart = CGPoint.zero
    fileprivate var minWidth: CGFloat = 48.0
    fileprivate var minHeight: CGFloat = 48.0
    open var preventsPositionOutsideSuperview = false

    fileprivate var anchorPoint: [CGFloat] = [0.0, 0.0, 0.0, 0.0]
    fileprivate var NoResizeAnchorPoint: [CGFloat] = [0.0, 0.0, 0.0, 0.0]
    fileprivate var UpperLeftAnchorPoint: [CGFloat] = [1.0, 1.0, -1.0, 1.0]
    fileprivate var MiddleLeftAnchorPoint: [CGFloat] = [1.0, 0.0, 0.0, 1.0]
    fileprivate var LowerLeftAnchorPoint: [CGFloat] = [1.0, 0.0, 1.0, 1.0]
    fileprivate var UpperMiddleAnchorPoint: [CGFloat] = [0.0, 1.0, -1.0, 0.0]
    fileprivate var UpperRightAnchorPoint: [CGFloat] = [0.0, 1.0, -1.0, -1.0]
    fileprivate var MiddleRightAnchorPoint: [CGFloat] = [0.0, 0.0, 0.0, -1.0]
    fileprivate var LowerRightAnchorPoint: [CGFloat] = [0.0, 0.0, 1.0, -1.0]
    fileprivate var LowerMiddleAnchorPoint: [CGFloat] = [0.0, 0.0, 1.0, 0.0]

    let GlobalInset: CGFloat = 0.0
    let InteractiveBorderSize: CGFloat = 15.0

    open var isContainer: Bool = false

    public convenience init(view: UIView,isContainer: Bool = false) {
        self.init(frame: view.frame)
        self.isContainer = isContainer
        contentView = view
    }

    public override init(frame: CGRect) {
        id = DraggableView.autoId
        super.init(frame: frame)
        setupDefaultAttributes()
    }

    public required init?(coder aDecoder: NSCoder) {
        id = DraggableView.autoId
        super.init(coder: aDecoder)
        setupDefaultAttributes()
    }

    func setupDefaultAttributes() {
        backgroundColor = .clear
        borderView = BorderView()
        let const = GlobalInset + InteractiveBorderSize / 2.0 - BorderView.BorderSize / 2.0
        addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.topAnchor.constraint(equalTo: topAnchor,constant: const).isActive = true
        borderView.leftAnchor.constraint(equalTo: leftAnchor,constant: const).isActive = true
        borderView.rightAnchor.constraint(equalTo: rightAnchor,constant: -const).isActive = true
        borderView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -const).isActive = true

        draggingHighlighter.alpha = 0.0
        insertSubview(draggingHighlighter,at: 0)
        draggingHighlighter.translatesAutoresizingMaskIntoConstraints = false
        draggingHighlighter.topAnchor.constraint(equalTo: topAnchor,constant: 0.0).isActive = true
        draggingHighlighter.leftAnchor.constraint(equalTo: leftAnchor,constant: 0.0).isActive = true
        draggingHighlighter.rightAnchor.constraint(equalTo: rightAnchor,constant: 0.0).isActive = true
        draggingHighlighter.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0.0).isActive = true

    }

    func isResizing() -> Bool {
        return anchorPoint[0] != 0.0
            || anchorPoint[1] != 0.0
            || anchorPoint[2] != 0.0
            || anchorPoint[3] != 0.0
    }

    fileprivate var isDraggingSub = false
    fileprivate weak var draggedSubView: DraggableView? = nil
    fileprivate lazy var highlighter: UIView =  {
        let view = UIView()
        view.backgroundColor  = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        return view
    }()

    fileprivate lazy var draggingHighlighter: UIView = {
        let view = UIView()
        view.backgroundColor  = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        return view
    }()

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesBegan(touches, with: event)
        // Notify the delegate we've begun our editing session.

        let touch = touches.first!

        if isContainer {
            let draggables = draggableSubs()
            for draggable in draggables.reversed() {
                if draggable.frame.contains(touch.location(in: self)){
                    isDraggingSub = true
                    draggedSubView = draggable
                    //_contentView?.bringSubview(toFront: draggable)
                    draggable.touchesBegan(touches, with: event)
                    _contentView?.insertSubview(highlighter, belowSubview: draggable)
                    highlighter.frame.size = self._contentView!.frame.size
                    return
                }
            }
        }

        anchorPoint = anchorPoint(forTouchLocation: touch.location(in: self))
        // When resizing, all calculations are done in the superview's coordinate space.

        touchStart = touch.location(in: superview)
        if !isResizing() {
            // When translating, all calculations are done in the view's coordinate space.
            touchStart = touch.location(in: self)
        }
        delegate?.userResizableViewDidBeginEditing(self)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTouch(touches, with: event)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTouch(touches, with: event)
    }

    fileprivate func endTouch(_ touches: Set<UITouch>, with event: UIEvent?){

        //draggingHighlighter.removeFromSuperview()
        //insertSubview(draggingHighlighter,at: 0)
        sendSubview(toBack: draggingHighlighter)
        draggingHighlighter.frame.size = self.frame.size
        UIView.animate(withDuration: 0.1){
            self.draggingHighlighter.alpha = 0.0
        }

        if isContainer {
            if let draggable = draggedSubView {
                draggable.touchesEnded(touches, with: event)

                if !draggable.superview!.frame.contains(draggable.center) {
                    delegate?.userResizableViewExtractView(self, viewToExtract: draggable)
                }
            }
        }
        highlighter.removeFromSuperview()
        isDraggingSub = false
        draggedSubView = nil

        if let container = underlayingContainer(){
            //add subview
            let currentCenter = self.center
            let newCenter = superview!.convert(currentCenter, to: container)

            self.removeFromSuperview()

            container.addSubViewToContainer(view: self)
            container.isHighlighted = false
            self.center = newCenter

        }

        delegate?.userResizableViewDidEndEditing(self)
        clearAlignmentIndicators()
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if isContainer,isDraggingSub {
            draggedSubView?.touchesMoved(touches, with: event)
            return
        }

        if isLocked {
            return
        }

        if isResizing() {
            var point = touches.first!.location(in: superview!)
            resize(usingTouchLocation: &point)
        }
        else {
            let point = touches.first!.location(in: self)
            if let container = underlayingContainer(){
                container.isHighlighted = true
            }
            translate(usingTouchLocation: point)
            delegate?.userResizableViewDidDrag(self)
            UIView.animate(withDuration: 0.1) {
                self.draggingHighlighter.alpha = 1.0
            }
        }

        showAlignmentIndicators()

    }

    open func draggableSubs()->[DraggableView]{
        var draggables: [DraggableView] = []
        for view in self._contentView!.subviews {
            if view is DraggableView {
                draggables.append(view as! DraggableView)
            }
        }

        return draggables
    }

    func resize(usingTouchLocation touchPoint: inout CGPoint) {
        // (1) Update the touch point if we're outside the superview.
        if preventsPositionOutsideSuperview {
            let border: CGFloat = GlobalInset //+ InteractiveBorderSize / 2
            if touchPoint.x < border {
                touchPoint.x = border
            }
            if touchPoint.x > superview!.bounds.size.width - border {
                touchPoint.x = superview!.bounds.size.width - border
            }
            if touchPoint.y < border {
                touchPoint.y = border
            }
            if touchPoint.y > superview!.bounds.size.height - border {
                touchPoint.y = superview!.bounds.size.height - border
            }
        }
        // (2) Calculate the deltas using the current anchor point.
        var deltaW: CGFloat = anchorPoint[3] * (touchStart.x - touchPoint.x)
        let deltaX: CGFloat = anchorPoint[0] * (-1.0 * deltaW)
        var deltaH: CGFloat = anchorPoint[2] * (touchPoint.y - touchStart.y)
        let deltaY: CGFloat = anchorPoint[1] * (-1.0 * deltaH)
        // (3) Calculate the new frame.
        var newX: CGFloat = frame.origin.x + deltaX
        var newY: CGFloat = frame.origin.y + deltaY
        var newWidth: CGFloat = frame.size.width + deltaW
        var newHeight: CGFloat = frame.size.height + deltaH
        // (4) If the new frame is too small, cancel the changes.
        if newWidth < minWidth {
            newWidth = frame.size.width
            newX = frame.origin.x
        }
        if newHeight < minHeight {
            newHeight = frame.size.height
            newY = frame.origin.y
        }
        // (5) Ensure the resize won't cause the view to move offscreen.
        if preventsPositionOutsideSuperview {
            if newX < superview!.bounds.origin.x {
                // Calculate how much to grow the width by such that the new X coordintae will align with the superview.
                deltaW = frame.origin.x - superview!.bounds.origin.x
                newWidth = frame.size.width + deltaW
                newX = superview!.bounds.origin.x
            }
            if newX + newWidth > superview!.bounds.origin.x + superview!.bounds.size.width {
                newWidth = superview!.bounds.size.width - newX
            }
            if newY < superview!.bounds.origin.y {
                // Calculate how much to grow the height by such that the new Y coordintae will align with the superview.
                deltaH = frame.origin.y - superview!.bounds.origin.y
                newHeight = frame.size.height + deltaH
                newY = superview!.bounds.origin.y
            }
            if newY + newHeight > superview!.bounds.origin.y + superview!.bounds.size.height {
                newHeight = superview!.bounds.size.height - newY
            }
        }
        self.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        //        if isContainer {
        //            _contentView?.frame = bounds.insetBy(dx: 0.0, dy: 0.0)
        //        }else {
        //            _contentView?.frame = bounds.insetBy(dx: GlobalInset + InteractiveBorderSize / 2, dy: GlobalInset + InteractiveBorderSize / 2)
        //        }
        //
        //borderView?.frame = bounds.insetBy(dx: GlobalInset, dy: GlobalInset)
        if let view = _contentView {
            recusiveSetNeedsDisplay(in: view)
        }
        borderView?.setNeedsDisplay()
        touchStart = touchPoint
    }

    func recusiveSetNeedsDisplay(in view: UIView){
        view.setNeedsDisplay()
        for sub in view.subviews {
            recusiveSetNeedsDisplay(in: sub)
        }
    }

    func translate(usingTouchLocation touchPoint: CGPoint) {
        var newCenter = CGPoint(x: center.x + touchPoint.x - touchStart.x, y: center.y + touchPoint.y - touchStart.y)
        if preventsPositionOutsideSuperview {
            // Ensure the translation won't cause the view to move offscreen.
            let midPointX: CGFloat = bounds.midX
            if newCenter.x > superview!.bounds.size.width - midPointX {
                newCenter.x = superview!.bounds.size.width - midPointX
            }
            if newCenter.x < midPointX {
                newCenter.x = midPointX
            }
            let midPointY: CGFloat = bounds.midY
            if newCenter.y > superview!.bounds.size.height - midPointY {
                newCenter.y = superview!.bounds.size.height - midPointY
            }
            if newCenter.y < midPointY {
                newCenter.y = midPointY
            }
        }
        center = newCenter
    }

    func anchorPoint(forTouchLocation touchPoint: CGPoint) -> [CGFloat] {
        // (1) Calculate the positions of each of the anchor points.
        let upperLeft: [CGFloat]? = resizeTop && resizeLeft ? [0.0,0.0] + UpperLeftAnchorPoint : nil
        let upperMiddle: [CGFloat]? = resizeTop ? [bounds.size.width / 2, 0.0] + UpperMiddleAnchorPoint : nil
        let upperRight: [CGFloat]? = resizeTop && resizeRight ? [bounds.size.width, 0.0] + UpperRightAnchorPoint : nil
        let middleRight: [CGFloat]? = resizeRight ? [bounds.size.width,bounds.size.height / 2] + MiddleRightAnchorPoint : nil
        let lowerRight: [CGFloat]? = resizeBottom && resizeRight ? [bounds.size.width, bounds.size.height] + LowerRightAnchorPoint : nil
        let lowerMiddle: [CGFloat]? = resizeBottom ? [bounds.size.width / 2, bounds.size.height] + LowerMiddleAnchorPoint : nil
        let lowerLeft: [CGFloat]? = resizeBottom && resizeLeft ? [0, bounds.size.height] + LowerLeftAnchorPoint : nil
        let middleLeft: [CGFloat]? = resizeLeft ? [0, bounds.size.height / 2] + MiddleLeftAnchorPoint : nil
        let centerPoint: [CGFloat] = [bounds.size.width / 2, bounds.size.height / 2] + NoResizeAnchorPoint
        // (2) Iterate over each of the anchor points and find the one closest to the user's touch.
        let allPoints: [[CGFloat]?] = [upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight, centerPoint]
        var smallestDistance: CGFloat = 30.0
        var closestPoint: [CGFloat] = centerPoint
        for i in 0..<9 {
            if let item = allPoints[i]{
                let distance: CGFloat = distanceBetweenTwoPoints(point1: touchPoint, point2: CGPoint(x: item[0],y: item[1]))
                if distance < smallestDistance {
                    closestPoint = item
                    smallestDistance = distance
                }
            }

        }
        return Array(closestPoint[2..<closestPoint.count])
    }

    func distanceBetweenTwoPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let dx: CGFloat = point2.x - point1.x
        let dy: CGFloat = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }

    open var contentView: UIView? {
        get{
            return _contentView
        }set{
            _contentView?.removeFromSuperview()
            _contentView = newValue
            _contentView?.isUserInteractionEnabled = false
            //_contentView?.frame = bounds.insetBy(dx: GlobalInset + InteractiveBorderSize / 2.0, dy: GlobalInset + InteractiveBorderSize / 2.0)
            let const: CGFloat = GlobalInset + InteractiveBorderSize / 2.0
            if let contentView = _contentView {
                addSubview(contentView)
                contentView.translatesAutoresizingMaskIntoConstraints = false
                contentView.topAnchor.constraint(equalTo: topAnchor,constant: const).isActive = true
                contentView.leftAnchor.constraint(equalTo: leftAnchor,constant: const).isActive = true
                contentView.rightAnchor.constraint(equalTo: rightAnchor,constant: -const).isActive = true
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -const).isActive = true
            }
            // Ensure the border view is always on top by removing it and adding it to the end of the subview list.
            bringSubview(toFront: borderView)
        }
    }

    open func addSubViewToContainer(view: UIView?){
        inseration?( self._contentView!, view)
    }

    func underlayingContainer()-> DraggableView?{
        var possibleContainers: [DraggableView] = []
        for view in superview!.subviews {
            if let container = view as? DraggableView,
                self != container,
                container.isContainer {
                container.isHighlighted = false
                if (container.frame.contains(center)) {
                    possibleContainers.append(container)
                }
            }
        }

        if possibleContainers.count >= 1 {
            return possibleContainers.first
        }
        return nil
    }

    override public var translatedFrame: CGRect {
        return convert(_contentView!.frame,to: superview!)
    }

    public var renderableDummy: UIView? {
        //check if we have a content view, else return nil
        if let contentView = _contentView {
            let copyOfContentView: UIView = isContainer ? contentView.clone() : contentView.cloneAsImage()
            if isContainer {
                copyOfContentView.subviews.forEach { $0.removeFromSuperview() }
                for draggableSub in contentView.subviews {
                    if draggableSub is DraggableView {
                        if let draggableView = draggableSub as? DraggableView,
                            let dummy =  draggableView.renderableDummy{
                            copyOfContentView.addSubview(dummy)
                            dummy.frame = draggableView.translatedFrame
                        }
                    }
                }
            }
            return copyOfContentView
        }else{
            return nil
        }
    }

}

public protocol ResizableViewDelegate: NSObjectProtocol {
    // Called when the resizable view receives touchesBegan: and activates the editing handles.
    func userResizableViewDidBeginEditing(_ userResizableView: DraggableView)

    // Called when the resizable view receives touchesEnded: or touchesCancelled:
    func userResizableViewDidEndEditing(_ userResizableView: DraggableView)

    func userResizableViewDidDrag(_ userResizableView: DraggableView)

    func userResizableViewExtractView(_ userResizableView: DraggableView,viewToExtract: DraggableView)
}


