//
//  ColorPicker.swift
//  MicroIBios
//
//  Created by Antonio Zaitoun on 20/03/2018.
//  Copyright © 2018 Antonio Zaitoun. All rights reserved.
//

import UIKit

@IBDesignable
public class ColorPicker: UIView {

    open var onColorChanged: ((UIColor)->Void)?

    open var onColorSelected: ((UIColor)->Void)?

    fileprivate var currentSelectionX: CGFloat = 0;
    fileprivate var selectedColor: UIColor!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3

    var elementSize: CGFloat = 5.0

    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        for y in stride(from: 0, to:  rect.height, by: elementSize) {

            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height

            for x in stride(from: 0,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }

        let rounded = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: rect.width, height: rect.height * 0.1))
        (selectedColor ?? UIColor.black).setFill()
        rounded.fill()
        UIColor.white.setStroke()
        rounded.stroke()
    }

    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    func getPointForColor(color:UIColor) -> CGPoint {
        var hue:CGFloat=0;
        var saturation:CGFloat=0;
        var brightness:CGFloat=0;
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);

        var yPos:CGFloat = 0
        let halfHeight = (self.bounds.height / 2)

        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }

        let xPos = hue * self.bounds.width

        return CGPoint(x: xPos, y: yPos)
    }


    //Changes the selected color, updates the UI, and notifies the delegate.
    open func selectedColor(sColor: UIColor){
        if (sColor != selectedColor)
        {
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0

            if sColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
                currentSelectionX = CGFloat (hue * self.frame.size.height);
                self.setNeedsDisplay();

            }
            selectedColor = sColor
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
                let touch =  touches.first
                updateColor(touch: touch!)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                let touch =  touches.first
        updateColor(touch: touch!)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                let touch =  touches.first
        updateColor(touch: touch!)
        onColorSelected?(selectedColor)
    }

    func updateColor(touch: UITouch){
        currentSelectionX = (touch.location(in: self).x)
        //selectedColor = UIColor(hue: (currentSelectionX / self.frame.size.width), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        //onColorChanged?(selectedColor)
        selectedColor = getColorAtPoint(point: touch.location(in: self))
        onColorChanged?(selectedColor)
        self.setNeedsDisplay()
    }
}
