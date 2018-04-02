import Foundation
import UIKit

public class PannableScrollView: UIScrollView,UIScrollViewDelegate {

    fileprivate var view: UIView!

    override public var frame: CGRect {
        didSet {
            if frame.size != oldValue.size { setZoomScale() }
        }
    }

    public init(view: UIView) {
        super.init(frame: .zero)

        self.view = view
        view.sizeToFit()
        addSubview(view)
        contentSize = view.bounds.size

        contentInsetAdjustmentBehavior = .never
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = true
        alwaysBounceVertical = true
        delegate = self
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setZoomScale() {
        let widthScale = frame.size.width / view.bounds.width
        let heightScale = frame.size.height / view.bounds.height
        let minScale = min(widthScale, heightScale)
        minimumZoomScale = minScale
        zoomScale = minScale
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return view
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if let view = view {
            let viewSize = view.frame.size
            let scrollViewSize = scrollView.bounds.size
            let verticalInset = viewSize.height < scrollViewSize.height ? (scrollViewSize.height - viewSize.height) / 2 : 0
            let horizontalInset = viewSize.width < scrollViewSize.width ? (scrollViewSize.width - viewSize.width) / 2 : 0
            scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        }
    }

    

}
