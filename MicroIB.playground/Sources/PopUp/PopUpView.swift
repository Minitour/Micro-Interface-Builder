//
//  PopUpView.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 20/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit


public class PopUpContainer: UIView {

    var snapshotView: UIView?
    var popUpView: PopUpView?

    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1506235665)
    }

    func setup(){
        if let popUpView = popUpView, let snapshotView = snapshotView {
            addSubview(snapshotView)
            addSubview(popUpView)
            let dir = popUpView.direction
            let center: CGPoint
            if dir == .bottom {
                let y = snapshotView.center.y - snapshotView.frame.height / 2.0 - popUpView.frame.height / 2.0
                center = CGPoint(x: snapshotView.center.x, y: y)
            }else {
                let y = snapshotView.center.y + snapshotView.frame.height / 2.0 + popUpView.frame.height / 2.0
                center = CGPoint(x: snapshotView.center.x, y: y)
            }
            popUpView.center = center

            popUpView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: [.curveEaseIn], animations: {
                popUpView.transform = .identity
            }, completion: nil)


        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let popUpView = popUpView {
            let point = touches.first!.location(in: popUpView)
            if !convert(popUpView.frame, to: popUpView).contains(point) {
                dimiss()
            }
        }

    }

    fileprivate func dimiss() {
        UIView.animate(withDuration: 0.2,animations: { [weak self] in
            self?.popUpView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { [weak self] (completion) in
            self?.removeFromSuperview()
        }
    }
}

@IBDesignable
public class PopUpView: UIView {

    open fileprivate(set) var container: UIView?

    open func dismiss(){
        if let popupContainer = superview as? PopUpContainer {
            popupContainer.dimiss()
        }
    }

    /// Create a custom pop up
    ///
    /// - Parameters:
    ///   - superview: The view in which the pop up will be contained.
    ///   - view: The view from which you are showing the pop up.
    ///   - using: The custom view that will be contained in the popup.
    ///   - dir: The direction of the pop up.
    @discardableResult
    public static func show(in superview: UIView,from view: UIView,using: UIView,direction dir: Direction = .bottom)-> PopUpView{

        //convert the snapshot view
        let snapshotView = view.snapshotView(afterScreenUpdates: false)

        //create popup container
        let popUpContainer = PopUpContainer(frame: superview.frame)
        popUpContainer.snapshotView = snapshotView
        let popUp = PopUpView(dir: dir,frame: using.frame)
        popUp.frame = CGRect(origin: .zero, size: using.frame.size)
        popUp.addView(view: using)
        snapshotView?.frame = view.convert(view.bounds, to: superview)//superview.convert(view.frame, to: popUpContainer)
        popUpContainer.popUpView = popUp
        popUpContainer.setup()

        //add container to the superview
        superview.addSubview(popUpContainer)
        return popUp
    }

    var direction: Direction = .bottom

    public convenience init(dir: Direction,frame: CGRect) {
        self.init(frame: frame)
        direction = dir
        setup()
        setNeedsDisplay()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(){
        isUserInteractionEnabled = true
        backgroundColor = .clear
        container = UIView()
        super.addSubview(container!)
        let space: CGFloat = (frame.width + frame.height) / 2.0 / 20.0
        container?.frame = bounds.insetBy(dx: space, dy: space)
        container?.center = center

        let topMultiplier: CGFloat = direction == .top ? 2.0 : 1.0
        let bottomMultiplier: CGFloat = direction == .top ? 1.0 : 2.0

        container?.translatesAutoresizingMaskIntoConstraints = false
        container?.topAnchor.constraint(equalTo: topAnchor,constant: space * topMultiplier).isActive = true
        container?.leftAnchor.constraint(equalTo: leftAnchor,constant: space).isActive = true
        container?.rightAnchor.constraint(equalTo: rightAnchor,constant: -space).isActive = true
        container?.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -space * bottomMultiplier).isActive = true
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
    }

    public override func draw(_ rect: CGRect) {

        let path = UIBezierPath()
        let space: CGFloat = (rect.width + rect.height) / 2.0 / 20.0

        if direction == .bottom {
            let point1 = CGPoint(x: rect.minX, y: space)
            let point2 = CGPoint(x: space, y: rect.minY)
            let point3 = CGPoint(x: rect.maxX - space, y: rect.minY)
            let point4 = CGPoint(x: rect.maxX, y: space)
            let point5 = CGPoint(x: rect.maxX, y: rect.maxY - space * 2.0)
            let point6 = CGPoint(x: rect.maxX - space, y: rect.maxY - space)
            let point7 = CGPoint(x: rect.midX + space, y: rect.maxY - space)
            let point8 = CGPoint(x: rect.midX, y: rect.maxY)
            let point9 = CGPoint(x: rect.midX - space, y: rect.maxY - space)
            let point10 = CGPoint(x: space, y: rect.maxY - space)
            let point11 = CGPoint(x: rect.minX, y: rect.maxY - space * 2.0)

            path.move(to: point1)
            path.addQuadCurve(to: point2, controlPoint: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: point3)
            path.addQuadCurve(to: point4, controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: point5)
            path.addQuadCurve(to: point6, controlPoint: CGPoint(x: rect.maxX, y: rect.maxY - space))
            path.addLine(to: point7)
            path.addQuadCurve(to: point8, controlPoint: CGPoint(x: rect.midX, y: rect.maxY - space/3.0))
            path.addQuadCurve(to: point9, controlPoint: CGPoint(x: rect.midX, y: rect.maxY - space/3.0))
            path.addLine(to: point10)
            path.addQuadCurve(to: point11, controlPoint: CGPoint(x: rect.minX, y: rect.maxY - space))

        }else {
            let point1 = CGPoint(x: rect.maxX, y: rect.maxY - space)
            let point2 = CGPoint(x: rect.maxX - space, y: rect.maxY)
            let point3 = CGPoint(x: rect.minX + space, y: rect.maxY)
            let point4 = CGPoint(x: rect.minX, y: rect.maxY - space)
            let point5 = CGPoint(x: rect.minX, y: rect.minY + space * 2.0)
            let point6 = CGPoint(x: rect.minX + space, y: rect.minY + space)
            let point7 = CGPoint(x: rect.midX - space, y: rect.minY + space)
            let point8 = CGPoint(x: rect.midX, y: rect.minY)
            let point9 = CGPoint(x: rect.midX + space, y: rect.minY + space)
            let point10 = CGPoint(x: rect.maxX - space, y: rect.minY + space)
            let point11 = CGPoint(x: rect.maxX, y: rect.minY + space * 2.0)

            path.move(to: point1)
            path.addQuadCurve(to: point2, controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: point3)
            path.addQuadCurve(to: point4, controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: point5)
            path.addQuadCurve(to: point6, controlPoint: CGPoint(x: rect.minX, y: rect.minY + space))
            path.addLine(to: point7)
            path.addQuadCurve(to: point8, controlPoint: CGPoint(x: rect.midX, y: rect.minY + space/3.0))
            path.addQuadCurve(to: point9, controlPoint: CGPoint(x: rect.midX, y: rect.minY + space/3.0))
            path.addLine(to: point10)
            path.addQuadCurve(to: point11, controlPoint: CGPoint(x: rect.maxX, y: rect.minY + space))
        }

        path.close()
        UIColor.white.set()
        path.fill()

    }

    func addView(view: UIView){
        if let container = container  {
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        }

        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
    }

    public enum Direction {
        case top
        case bottom
    }
}

extension UIView
{
    public func renderToImage(afterScreenUpdates: Bool = false) -> UIImage?
    {
        if #available(iOS 10.0, *)
        {
            let rendererFormat = UIGraphicsImageRendererFormat.default()
            rendererFormat.scale = self.layer.contentsScale
            rendererFormat.opaque = self.isOpaque
            let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: rendererFormat)

            return
                renderer.image
                    {
                        _ in

                        self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
            }
        }
        else
        {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, self.layer.contentsScale)
            defer
            {
                UIGraphicsEndImageContext()
            }

            self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)

            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
}

