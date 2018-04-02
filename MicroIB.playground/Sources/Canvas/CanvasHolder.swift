import Foundation
import UIKit


public class CanvasHolder: UIView {

    let zooms:[CGFloat] = [0.0625,
                           0.125,
                           0.25,
                           0.5,
                           0.75,
                           1.0,
                           1.25,
                           1.5,
                           2.0,
                           3.0,
                           4.0]

    let width: CGFloat = 600.0
    let height: CGFloat = 800.0
    let canvasHolderSize: CGFloat = 1000.0

    open fileprivate(set) var canvas: CanvasView!

    fileprivate var scrollView: PannableScrollView!

    fileprivate var canvasHolder: UIView!

    fileprivate lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.backgroundColor = .white
        stepper.layer.cornerRadius = 3.0
        stepper.layer.masksToBounds = true
        
        return stepper
    }()

    public override init(frame: CGRect){
        super.init(frame: frame)

        let mainColor = #colorLiteral(red: 0.9293106794, green: 0.929469943, blue: 0.9293007255, alpha: 1)

        canvasHolder = UIView(frame: CGRect(x: 0, y: 0, width: canvasHolderSize, height: canvasHolderSize))
        canvasHolder.backgroundColor = mainColor
        canvas = CanvasView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        canvas.backgroundColor = .white
        canvasHolder.addSubview(canvas)
        canvas.center = canvasHolder.center



        scrollView = PannableScrollView(view: canvasHolder)
        scrollView.backgroundColor = mainColor
        scrollView.minimumZoomScale = 0.0625
        scrollView.maximumZoomScale = 4.0
        scrollView.bounces = false
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        canvas.scrollView = scrollView

        //scrollView.isScrollEnabled = false

        addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.leftAnchor.constraint(equalTo: leftAnchor,constant: 20.0).isActive = true
        stepper.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8.0).isActive = true
        stepper.addTarget(self,action: #selector(didTapStepper(_:)),for: .valueChanged)

        stepper.minimumValue = 0
        stepper.maximumValue = 9
        stepper.value = 1
        stepper.stepValue = 1
        stepper.value = 5
        stepper.layer.cornerRadius = 4.0
        stepper.layer.masksToBounds = true

    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func didMoveToSuperview() {

        canvas.center = canvasHolder.center

        let centerOffsetX = (canvasHolderSize - width) / 2
        let centerOffsetY = (canvasHolderSize - height * 0.65) / 2
        let centerPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
        scrollView.setContentOffset(centerPoint, animated: false)
    }

    @objc
    func didTapStepper(_ sender: UIStepper){
        let value = sender.value
        UIView.animate(withDuration: 0.2) {
            self.scrollView.zoomScale = self.zooms[Int(value)]
        }

    }
}
