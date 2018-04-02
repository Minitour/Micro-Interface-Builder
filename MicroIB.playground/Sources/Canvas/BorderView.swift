//
//  BorderView.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 15/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import Foundation
import UIKit

public class BorderView: UIView {
    public static let BorderSize: CGFloat = 10.0
    let borderColor: UIColor = #colorLiteral(red: 0.5254901961, green: 0.568627451, blue: 1, alpha: 1)
    let InteractiveBorderSize: CGFloat = BorderView.BorderSize

    public var top: Bool = true
    public var bottom: Bool = true
    public var left: Bool = true
    public var right: Bool = true

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()

        context.setLineWidth(1.0)
        context.setStrokeColor(borderColor.cgColor)
        context.addRect(bounds.insetBy(dx: InteractiveBorderSize / 2.0, dy: InteractiveBorderSize / 2.0))
        context.strokePath()

        let upperLeft = top && left ? CGRect(x: 0.0, y: 0.0, width: InteractiveBorderSize, height: InteractiveBorderSize) : nil
        let upperRight = top && right ? CGRect(x: bounds.size.width - InteractiveBorderSize, y: 0.0, width: InteractiveBorderSize, height: InteractiveBorderSize) : nil
        let lowerRight = bottom && right ? CGRect(x: bounds.size.width - InteractiveBorderSize, y: bounds.size.height - InteractiveBorderSize, width: InteractiveBorderSize, height: InteractiveBorderSize) : nil
        let lowerLeft = bottom && left ? CGRect(x: 0.0, y: bounds.size.height - InteractiveBorderSize, width: InteractiveBorderSize, height: InteractiveBorderSize) : nil
        let upperMiddle = top ? CGRect(x: (bounds.size.width - InteractiveBorderSize) / 2, y: 0.0, width: InteractiveBorderSize, height: InteractiveBorderSize) : nil
        let lowerMiddle = bottom ? CGRect(x: (bounds.size.width - InteractiveBorderSize) / 2, y: bounds.size.height - InteractiveBorderSize, width: InteractiveBorderSize, height: InteractiveBorderSize) : nil
        let middleLeft = left ? CGRect(x: 0.0, y: (bounds.size.height - InteractiveBorderSize) / 2, width: InteractiveBorderSize, height: InteractiveBorderSize) : nil
        let middleRight = right ? CGRect(x: bounds.size.width - InteractiveBorderSize, y: (bounds.size.height - InteractiveBorderSize) / 2, width: InteractiveBorderSize, height: InteractiveBorderSize) : nil


        let colors: [CGFloat] = Array<CGFloat>(repeating: 1.0, count: 8)
        let baseSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: baseSpace, colorComponents: colors, locations: nil, count: 2)

        context.setLineWidth(0.3)
        context.setShadow(offset: CGSize(width: 0.5, height: 0.5), blur: 1.0)
        context.setStrokeColor(UIColor.gray.cgColor)

        var allPoints: [CGRect?] = [upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight]

        for i in 0..<8 {
            if let currPoint: CGRect = allPoints[i]{
                context.saveGState()
                context.addRect(currPoint)
                context.clip()
                let startPoint = CGPoint(x: currPoint.midX, y: currPoint.minY)
                let endPoint = CGPoint(x: currPoint.midX, y: currPoint.maxY)
                context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
                context.restoreGState()
                context.stroke(currPoint)
            }
        }
    }
}
