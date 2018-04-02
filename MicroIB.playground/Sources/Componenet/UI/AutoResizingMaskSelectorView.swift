//
//  AutoResizingMaskSelectorView.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 19/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
public class AutoResizingMaskSelectorView: UIView {

    open var onMaskChanged: ((UIViewAutoresizing)-> Void)?

    fileprivate var top: Bool = true
    fileprivate var left: Bool = true
    fileprivate var right: Bool = false
    fileprivate var bottom: Bool = false
    fileprivate var width: Bool = false
    fileprivate var height: Bool = false

    fileprivate let lineWidth: CGFloat = 10.0
    fileprivate let lineHeight: CGFloat = 1.0

    fileprivate let markedColor: UIColor = #colorLiteral(red: 1, green: 0.2803861539, blue: 0.2746742296, alpha: 1)
    fileprivate let unmarkedColor: UIColor = #colorLiteral(red: 1, green: 0.5970429072, blue: 0.6189696611, alpha: 1)

    fileprivate var topRect: CGRect {
        return CGRect(x: frame.height / 4.0, y: 0, width: frame.width / 2.0, height: frame.height / 4.0)
    }

    fileprivate var bottomRect: CGRect {
        return CGRect(x: frame.height / 4.0, y: frame.height / 4.0 + frame.height / 2.0, width: frame.width / 2.0, height: frame.height / 4.0)
    }

    fileprivate var leftRect: CGRect {
        return CGRect(x: 0, y: frame.height / 4.0, width: frame.width / 4.0, height: frame.height / 2.0)
    }

    fileprivate var rightRect: CGRect {
        return CGRect(x: frame.width / 4.0 + frame.width / 2.0, y: frame.height / 4.0, width: frame.width / 4.0, height: frame.height / 2.0)
    }

    fileprivate var heightRect: CGRect {
        return CGRect(x: frame.width / 2.0 - lineWidth , y: frame.height/4.0 - lineHeight, width: lineWidth * 2.0, height: frame.height / 2.0)
    }

    fileprivate var widthRect: CGRect {
        return CGRect(x: frame.width / 4.0 - lineHeight, y: frame.height/2.0 - lineWidth, width: frame.width / 2.0, height: lineWidth * 2.0)
    }

    public var selectedMask: UIViewAutoresizing {
        set {
            top = newValue.contains(.flexibleTopMargin)
            bottom = newValue.contains(.flexibleBottomMargin)
            left = newValue.contains(.flexibleLeftMargin)
            right = newValue.contains(.flexibleRightMargin)
            width = newValue.contains(.flexibleWidth)
            height = newValue.contains(.flexibleHeight)
            setNeedsDisplay()
        }get{
            var masks = UIViewAutoresizing()

            if top { masks.insert(.flexibleTopMargin) }

            if bottom { masks.insert(.flexibleBottomMargin) }

            if left { masks.insert(.flexibleLeftMargin) }

            if right { masks.insert(.flexibleRightMargin) }

            if width { masks.insert(.flexibleWidth) }

            if height { masks.insert(.flexibleHeight) }

            return masks
        }
    }


    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    fileprivate func setup() {
        isUserInteractionEnabled = true
        layer.cornerRadius = 5.0
        backgroundColor = .clear
    }

    public override func draw(_ rect: CGRect) {
        #if TARGET_INTERFACE_BUILDER
            // Run this code only in Interface Builder
            #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 0.2821698203).set()
            UIBezierPath(rect: topRect).stroke()
            UIBezierPath(rect: bottomRect).stroke()
            UIBezierPath(rect: rightRect).stroke()
            UIBezierPath(rect: leftRect).stroke()
            UIBezierPath(rect: widthRect).stroke()
            UIBezierPath(rect: heightRect).stroke()
        #endif

        let w = rect.width
        let h = rect.height

        #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).set()

        //draw outter rect
        let outter = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius)
        outter.stroke()

        //draw inner view
        let innerFrame = CGRect(x: w/4.0, y: h/4.0, width: w/2.0, height: h/2.0)
        let path = UIBezierPath(roundedRect: innerFrame,cornerRadius: layer.cornerRadius/4.0)
        path.stroke()

        //add outter top line
        let outterTop = UIBezierPath()
        outterTop.move(to: CGPoint(x: w/2.0 - lineWidth/2.0, y: lineHeight))
        outterTop.addLine(to: CGPoint(x: w/2.0 + lineWidth/2.0, y: lineHeight))


        //add outter bottom line
        let outterBottom = UIBezierPath()
        outterBottom.move(to: CGPoint(x: w/2.0 - lineWidth/2.0, y: h - lineHeight))
        outterBottom.addLine(to: CGPoint(x: w/2.0 + lineWidth/2.0, y: h - lineHeight))


        //add outter left line
        let outterLeft = UIBezierPath()
        outterLeft.move(to: CGPoint(x: lineHeight, y: h/2.0 - lineWidth/2.0))
        outterLeft.addLine(to: CGPoint(x: lineHeight, y: h/2.0 + lineWidth/2.0))


        //add outter right line
        let outterRight = UIBezierPath()
        outterRight.move(to: CGPoint(x: w - lineHeight, y: h/2.0 - lineWidth/2.0))
        outterRight.addLine(to: CGPoint(x: w - lineHeight, y: h/2.0 + lineWidth/2.0))


        //add inner top line
        let innerTop = UIBezierPath()
        innerTop.move(to: CGPoint(x: w/2.0 - lineWidth/2.0, y: h/4.0 - lineHeight))
        innerTop.addLine(to: CGPoint(x: w/2.0 + lineWidth/2.0,y: h/4.0 - lineHeight))


        //add inner bottom line
        let innerBottom = UIBezierPath()
        innerBottom.move(to: CGPoint(x: w/2.0 - lineWidth/2.0, y: h/2.0 + h/4.0 + lineHeight))
        innerBottom.addLine(to: CGPoint(x: w/2.0 + lineWidth/2.0, y: h/2.0 + h/4.0 + lineHeight))


        //add inner left line
        let innerLeft = UIBezierPath()
        innerLeft.move(to: CGPoint(x: w/4.0 - lineHeight, y: h/2.0 - lineWidth/2.0))
        innerLeft.addLine(to: CGPoint(x: w/4.0 - lineHeight, y: h/2.0 + lineWidth/2.0))


        //add inner right line
        let innerRight = UIBezierPath()
        innerRight.move(to: CGPoint(x: w/2.0 + w/4.0 + lineHeight, y: h/2.0 - lineWidth/2.0))
        innerRight.addLine(to: CGPoint(x: w/2.0 + w/4.0 + lineHeight, y: h/2.0 + lineWidth/2.0))


        //add top line
        let lineTop = UIBezierPath()
        lineTop.move(to: CGPoint(x: w/2.0, y: lineHeight))
        lineTop.addLine(to: CGPoint(x: w/2.0,y: h/4.0 - lineHeight))


        //add bottom line
        let lineBottom = UIBezierPath()
        lineBottom.move(to: CGPoint(x: w/2.0, y: h/2.0 + h/4.0 + lineHeight))
        lineBottom.addLine(to: CGPoint(x: w/2.0, y: h - lineHeight))


        //add left line
        let lineLeft = UIBezierPath()
        lineLeft.move(to: CGPoint(x: lineHeight, y: h/2.0))
        lineLeft.addLine(to: CGPoint(x: w/4.0 - lineHeight, y: h/2.0))


        //add right line
        let lineRight = UIBezierPath()
        lineRight.move(to: CGPoint(x: w/2.0 + w/4.0 + lineHeight, y: h/2.0))
        lineRight.addLine(to: CGPoint(x: w - lineHeight, y: h/2.0))


        //add height line
        let lineH = UIBezierPath()
        lineH.move(to: CGPoint(x: w/2.0, y: h/4.0 + lineHeight))
        lineH.addLine(to: CGPoint(x: w/2.0, y: h/4.0 + h/2.0 - lineHeight))

        let arrowLeftTop = UIBezierPath()
        arrowLeftTop.move(to: CGPoint(x: w/2.0, y: h/4.0 + lineHeight))
        arrowLeftTop.addLine(to: CGPoint(x: w/2.0 - lineWidth / 2.0, y: h/4.0 + lineHeight + lineWidth / 2.0))

        let arrowRightTop = UIBezierPath()
        arrowRightTop.move(to: CGPoint(x: w/2.0, y: h/4.0 + lineHeight))
        arrowRightTop.addLine(to: CGPoint(x: w/2.0 + lineWidth / 2.0, y: h/4.0 + lineHeight + lineWidth / 2.0))

        let arrowLeftBottom = UIBezierPath()
        arrowLeftBottom.move(to: CGPoint(x: w/2.0, y: h/4.0 + h/2.0 - lineHeight))
        arrowLeftBottom.addLine(to: CGPoint(x: w/2.0 - lineWidth / 2.0, y: h/4.0 + h/2.0 - lineHeight - lineWidth / 2.0))

        let arrowRightBottom = UIBezierPath()
        arrowRightBottom.move(to: CGPoint(x: w/2.0, y: h/4.0 + h/2.0 - lineHeight))
        arrowRightBottom.addLine(to: CGPoint(x: w/2.0 + lineWidth / 2.0, y: h/4.0 + h/2.0 - lineHeight - lineWidth / 2.0))

        //add width line
        let lineW = UIBezierPath()
        lineW.move(to: CGPoint(x: w/4.0 + lineHeight, y: h/2.0))
        lineW.addLine(to: CGPoint(x: w/2.0 + w/4.0 - lineHeight, y: h/2.0))

        let arrowLeftTopV = UIBezierPath()
        arrowLeftTopV.move(to: CGPoint(x: w / 4.0 + lineHeight, y: h / 2.0))
        arrowLeftTopV.addLine(to: CGPoint(x: w / 4.0 + lineWidth / 2.0, y: h / 2.0 + lineHeight - lineWidth / 2.0))

        let arrowLeftBottomV = UIBezierPath()
        arrowLeftBottomV.move(to: CGPoint(x: w / 4.0 + lineHeight, y: h / 2.0))
        arrowLeftBottomV.addLine(to: CGPoint(x: w / 4.0 + lineWidth / 2.0, y: h / 2.0 + lineHeight + lineWidth / 2.0))

        let arrowRightTopV = UIBezierPath()
        arrowRightTopV.move(to: CGPoint(x: w/2.0 + w/4.0 - lineHeight, y: h/2.0))
        arrowRightTopV.addLine(to: CGPoint(x: w/2.0 + w/4.0 - lineHeight - lineWidth / 2.0, y: h/2.0 - lineWidth / 2.0))

        let arrowRightBottomV = UIBezierPath()
        arrowRightBottomV.move(to: CGPoint(x: w/2.0 + w/4.0 - lineHeight, y: h/2.0))
        arrowRightBottomV.addLine(to: CGPoint(x: w/2.0 + w/4.0 - lineHeight - lineWidth / 2.0, y: h/2.0 + lineWidth / 2.0))



        let pattern: [CGFloat] = [2.0,1.0]
        let phase: CGFloat = 0.0

        if top {
            markedColor.set()
        }else{
            unmarkedColor.set()
            lineTop.setLineDash(pattern, count: pattern.count, phase: phase)
        }

        outterTop.stroke()
        innerTop.stroke()
        lineTop.stroke()

        if bottom {
            markedColor.set()
        }else{
            unmarkedColor.set()
            lineBottom.setLineDash(pattern, count: pattern.count, phase: phase)
        }
        outterBottom.stroke()
        innerBottom.stroke()
        lineBottom.stroke()

        if left {
            markedColor.set()
        }else{
            unmarkedColor.set()
            lineLeft.setLineDash(pattern, count: pattern.count, phase: phase)
        }
        outterLeft.stroke()
        innerLeft.stroke()
        lineLeft.stroke()

        if right {
            markedColor.set()
        }else{
            unmarkedColor.set()
            lineRight.setLineDash(pattern, count: pattern.count, phase: phase)
        }
        outterRight.stroke()
        innerRight.stroke()
        lineRight.stroke()


        if height {
            markedColor.set()
            arrowLeftTop.stroke()
            arrowRightTop.stroke()
            arrowLeftBottom.stroke()
            arrowRightBottom.stroke()
        }else {
            unmarkedColor.set()
            lineH.setLineDash(pattern, count: pattern.count, phase: phase)
        }
        lineH.stroke()


        if width {
            markedColor.set()
            arrowLeftTopV.stroke()
            arrowLeftBottomV.stroke()
            arrowRightTopV.stroke()
            arrowRightBottomV.stroke()
        }else {
            unmarkedColor.set()
            lineW.setLineDash(pattern, count: pattern.count, phase: phase)
        }
        lineW.stroke()

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first!.location(in: self)

        if topRect.contains(touch) {
            top = !top
        }

        if leftRect.contains(touch) {
            left = !left
        }

        if rightRect.contains(touch) {
            right = !right
        }

        if bottomRect.contains(touch) {
            bottom = !bottom
        }

        if heightRect.contains(touch) && widthRect.contains(touch) {
            height = !height
        }else {
            if heightRect.contains(touch) {
                height = !height
            }

            if widthRect.contains(touch) {
                width = !width
            }
        }

        onMaskChanged?(selectedMask)

        setNeedsDisplay()
    }


}
