//
//  CheckBox.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 23/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

public class Checkbox: UIControl {


    public var borderWidth: CGFloat = 2
    public var checkmarkSize: CGFloat = 0.5
    public var uncheckedBorderColor: UIColor!
    public var checkedBorderColor: UIColor!
    public var checkmarkColor: UIColor!
    public var checkboxBackgroundColor: UIColor! = .white
    public var increasedTouchRadius: CGFloat = 5
    public var valueChanged: ((_ isChecked: Bool) -> Void)?
    public var isChecked: Bool = false {
        didSet { setNeedsDisplay() }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.init(white: 1, alpha: 0)
        uncheckedBorderColor = tintColor
        checkedBorderColor = tintColor
        checkmarkColor = tintColor

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
        addGestureRecognizer(tapGesture)
    }

    override public func draw(_ rect: CGRect) {
        let rectanglePath = UIBezierPath(rect: rect)

        if isChecked {
            checkedBorderColor.setStroke()
        } else {
            uncheckedBorderColor.setStroke()
        }

        rectanglePath.lineWidth = borderWidth
        rectanglePath.stroke()
        checkboxBackgroundColor.setFill()
        rectanglePath.fill()

        if isChecked {
            let rect = checkmarkRect(in: rect)
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: rect.minX + 0.04688 * rect.width, y: rect.minY + 0.63548 * rect.height))
            bezierPath.addLine(to: CGPoint(x: rect.minX + 0.34896 * rect.width, y: rect.minY + 0.95161 * rect.height))
            bezierPath.addLine(to: CGPoint(x: rect.minX + 0.95312 * rect.width, y: rect.minY + 0.04839 * rect.height))
            checkmarkColor.setStroke()
            bezierPath.lineWidth = checkmarkSize * 2
            bezierPath.stroke()
        }
    }


    private func checkmarkRect(in rect: CGRect) -> CGRect {
        let width = rect.maxX * checkmarkSize
        let height = rect.maxY * checkmarkSize
        let adjustedRect = CGRect(x: (rect.maxX - width) / 2,
                                  y: (rect.maxY - height) / 2,
                                  width: width,
                                  height: height)
        return adjustedRect
    }

    @objc
    private func handleTapGesture(recognizer: UITapGestureRecognizer) {
        isChecked = !isChecked
        valueChanged?(isChecked)
    }

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsetsMake(-increasedTouchRadius,
                                                 -increasedTouchRadius,
                                                 -increasedTouchRadius,
                                                 -increasedTouchRadius)
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
        return hitFrame.contains(point)
    }

}
