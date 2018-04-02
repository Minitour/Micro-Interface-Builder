import UIKit


public extension UIView {
    public func showAlignmentIndicators(){
        AlignmentIndicatorViews.shared.identifyViews(currentView: self, parentView: self.superview!, otherViews: self.superview!.subviews)
    }

    public func showAlignmentIndicators(inRespectTo view: UIView,subViews: [UIView]){
        AlignmentIndicatorViews.shared.identifyViews(currentView: self, parentView: view, otherViews: subViews)
    }

    public func clearAlignmentIndicators(){
        let ob = AlignmentIndicatorViews.shared
        if let superview = self.superview {
            ob.identifyViews(currentView: self, parentView: superview, otherViews: superview.subviews)
        }
        ob.clearLayersLines()
    }

    @objc
    public var translatedFrame: CGRect {
        return self.frame
    }
}

public class AlignmentIndicatorViews {

    static let shared : AlignmentIndicatorViews = {
        let instance = AlignmentIndicatorViews()
        return instance
    }()
    private var lineColor = #colorLiteral(red: 0.2235294118, green: 0.2823529412, blue: 1, alpha: 1)
    private var lineWidth: CGFloat = 0.6

    private var layersLines: [CALayer]?

    private var otherViews: [UIView]!
    private var currentView: UIView!
    private var parentView: UIView!

    func identifyViews(currentView: UIView, parentView: UIView, otherViews: [UIView]){

        self.currentView = currentView
        self.parentView = parentView
        self.otherViews = otherViews

        self.clearLayersLines()

        self.alignment_center_view()

        if self.otherViews.count > 1{

            self.alignment_top_top()
            self.alignment_top_bot()
            self.alignment_bot_bot()
            self.alignment_bot_top()

            self.alignment_left_left()
            self.alignment_right_right()
            self.alignment_left_right()
            self.alignment_right_left()

            self.alignment_center_center_horizontal()
            self.alignment_top_center_horizontal()
            self.alignment_bot_center_horizontal()

            self.alignment_center_center_vertical()
            self.alignment_right_center_vertical()
            self.alignment_left_center_vertical()

        }

    }

    private func alignment_center_center_vertical(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsAcima: [UIView] = []
        var viewsAbaixo: [UIView] = []

        let listOrderY = self.otherViews.sorted { $0.translatedFrame.origin.y == $1.translatedFrame.origin.y }

        for dragView in listOrderY{

            if currentView != dragView{

                let pointXOrigem: CGFloat = viewOrigemFrame.origin.x + (viewOrigemFrame.width / 2)

                let pointXDrag: CGFloat = dragView.translatedFrame.origin.x + (dragView.translatedFrame.width / 2)

                if pointXOrigem.distance(to: pointXDrag) <= 1 && pointXOrigem.distance(to: pointXDrag) >= -1{

                    if dragView.translatedFrame.origin.y < viewOrigemFrame.origin.y{

                        viewsAcima.append(dragView)

                    }else if dragView.translatedFrame.origin.y > viewOrigemFrame.origin.y{

                        viewsAbaixo.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsAcima.count > 0{

            primeiraView = viewsAcima.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x + (primeiraView.translatedFrame.width / 2), yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + (ultimaView.translatedFrame.width / 2), yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }else if viewsAbaixo.count > 0{

            primeiraView = currentView
            ultimaView = viewsAbaixo.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x + (primeiraView.translatedFrame.width / 2), yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + (ultimaView.translatedFrame.width / 2), yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }

    }

    private func alignment_right_center_vertical(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsAcima: [UIView] = []
        var viewsAbaixo: [UIView] = []

        let listOrderY = self.otherViews.sorted { $0.translatedFrame.origin.y == $1.translatedFrame.origin.y }

        for dragView in listOrderY{

            if currentView != dragView{

                let pointXOrigem: CGFloat = viewOrigemFrame.origin.x + viewOrigemFrame.width

                let pointXDrag: CGFloat = dragView.translatedFrame.origin.x + (dragView.translatedFrame.width / 2)

                if pointXOrigem.distance(to: pointXDrag) <= 1 && pointXOrigem.distance(to: pointXDrag) >= -1{

                    if dragView.translatedFrame.origin.y < viewOrigemFrame.origin.y{

                        viewsAcima.append(dragView)

                    }else if dragView.translatedFrame.origin.y > viewOrigemFrame.origin.y{

                        viewsAbaixo.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsAcima.count > 0{

            primeiraView = viewsAcima.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x + (primeiraView.translatedFrame.width / 2), yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }else if viewsAbaixo.count > 0{

            primeiraView = currentView
            ultimaView = viewsAbaixo.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x + primeiraView.translatedFrame.width, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + (ultimaView.translatedFrame.width / 2), yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }

    }

    private func alignment_left_center_vertical(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsAcima: [UIView] = []
        var viewsAbaixo: [UIView] = []

        let listOrderY = self.otherViews.sorted { $0.translatedFrame.origin.y == $1.translatedFrame.origin.y }

        for dragView in listOrderY{

            if currentView != dragView{

                let pointXOrigem: CGFloat = viewOrigemFrame.origin.x

                let pointXDrag: CGFloat = dragView.translatedFrame.origin.x + (dragView.translatedFrame.width / 2)

                if pointXOrigem.distance(to: pointXDrag) <= 1 && pointXOrigem.distance(to: pointXDrag) >= -1{

                    if dragView.translatedFrame.origin.y < viewOrigemFrame.origin.y{

                        viewsAcima.append(dragView)

                    }else if dragView.translatedFrame.origin.y > viewOrigemFrame.origin.y{

                        viewsAbaixo.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsAcima.count > 0{

            primeiraView = viewsAcima.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x + (primeiraView.translatedFrame.width / 2), yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }else if viewsAbaixo.count > 0{

            primeiraView = currentView
            ultimaView = viewsAbaixo.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + (ultimaView.translatedFrame.width / 2), yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }

    }

    private func alignment_center_center_horizontal(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsEsquerda: [UIView] = []
        var viewsDireita: [UIView] = []

        let listOrderX = self.otherViews.sorted { $0.translatedFrame.origin.x == $1.translatedFrame.origin.x }

        for dragView in listOrderX{

            if currentView != dragView{

                let pointYOrigem: CGFloat = viewOrigemFrame.origin.y + (viewOrigemFrame.height / 2)

                let pointYInferior: CGFloat = dragView.translatedFrame.origin.y + (dragView.translatedFrame.height / 2)

                if pointYOrigem.distance(to: pointYInferior) <= 1 && pointYOrigem.distance(to: pointYInferior) >= -1{

                    if dragView.translatedFrame.origin.x < viewOrigemFrame.origin.x{

                        viewsEsquerda.append(dragView)

                    }else if dragView.translatedFrame.origin.x > viewOrigemFrame.origin.x{

                        viewsDireita.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsEsquerda.count > 0{

            primeiraView = viewsEsquerda.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y + (primeiraView.translatedFrame.height / 2), xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + (ultimaView.translatedFrame.height / 2))

        }else if viewsDireita.count > 0{

            primeiraView = currentView
            ultimaView = viewsDireita.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y + (primeiraView.translatedFrame.height / 2), xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + (ultimaView.translatedFrame.height / 2))

        }

    }

    private func alignment_top_center_horizontal(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsEsquerda: [UIView] = []
        var viewsDireita: [UIView] = []

        let listOrderX = self.otherViews.sorted { $0.translatedFrame.origin.x == $1.translatedFrame.origin.x }

        for dragView in listOrderX{

            if currentView != dragView{

                let pointYOrigem: CGFloat = viewOrigemFrame.origin.y

                let pointYInferior: CGFloat = dragView.translatedFrame.origin.y + (dragView.translatedFrame.height / 2)

                if pointYOrigem.distance(to: pointYInferior) <= 1 && pointYOrigem.distance(to: pointYInferior) >= -1{

                    if dragView.translatedFrame.origin.x < viewOrigemFrame.origin.x{

                        viewsEsquerda.append(dragView)

                    }else if dragView.translatedFrame.origin.x > viewOrigemFrame.origin.x{

                        viewsDireita.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsEsquerda.count > 0{

            primeiraView = viewsEsquerda.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y + (primeiraView.translatedFrame.height / 2), xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y)

        }else if viewsDireita.count > 0{

            primeiraView = currentView
            ultimaView = viewsDireita.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + (ultimaView.translatedFrame.height / 2))

        }

    }

    private func alignment_bot_center_horizontal(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsEsquerda: [UIView] = []
        var viewsDireita: [UIView] = []

        let listOrderX = self.otherViews.sorted { $0.translatedFrame.origin.x == $1.translatedFrame.origin.x }

        for dragView in listOrderX{

            if currentView != dragView{

                let pointYOrigem: CGFloat = viewOrigemFrame.origin.y + viewOrigemFrame.height

                let pointYInferior: CGFloat = dragView.translatedFrame.origin.y + (dragView.translatedFrame.height / 2)

                if pointYOrigem.distance(to: pointYInferior) <= 1 && pointYOrigem.distance(to: pointYInferior) >= -1{

                    if dragView.translatedFrame.origin.x < viewOrigemFrame.origin.x{

                        viewsEsquerda.append(dragView)

                    }else if dragView.translatedFrame.origin.x > viewOrigemFrame.origin.x{

                        viewsDireita.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsEsquerda.count > 0{

            primeiraView = viewsEsquerda.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y + (primeiraView.translatedFrame.height / 2), xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }else if viewsDireita.count > 0{

            primeiraView = currentView
            ultimaView = viewsDireita.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y + primeiraView.translatedFrame.height, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + (ultimaView.translatedFrame.height / 2))

        }

    }

    private func alignment_left_left(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsAcima: [UIView] = []
        var viewsAbaixo: [UIView] = []

        let listOrderY = self.otherViews.sorted { $0.translatedFrame.origin.y == $1.translatedFrame.origin.y }

        for dragView in listOrderY{

            if currentView != dragView{

                if viewOrigemFrame.origin.x.distance(to: dragView.translatedFrame.origin.x) <= 1 && viewOrigemFrame.origin.x.distance(to: dragView.translatedFrame.origin.x) >= -1{

                    if dragView.translatedFrame.origin.y < viewOrigemFrame.origin.y{

                        viewsAcima.append(dragView)

                    }else if dragView.translatedFrame.origin.y > viewOrigemFrame.origin.y{

                        viewsAbaixo.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsAcima.count > 0{

            primeiraView = viewsAcima.first!
            ultimaView = currentView

        }else if viewsAbaixo.count > 0{

            primeiraView = currentView
            ultimaView = viewsAbaixo.last!

        }

        if primeiraView == ultimaView{
            return
        }

        self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

    }

    private func alignment_right_right(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsEsquerda: [UIView] = []
        var viewsDireita: [UIView] = []

        let listOrderY = self.otherViews.sorted { $0.translatedFrame.origin.y == $1.translatedFrame.origin.y }

        for dragView in listOrderY{

            if currentView != dragView{

                let pointXOrigem: CGFloat = viewOrigemFrame.origin.x + viewOrigemFrame.width

                let pointXDireita: CGFloat = dragView.translatedFrame.origin.x + dragView.translatedFrame.width

                if pointXOrigem.distance(to: pointXDireita) <= 1 && pointXOrigem.distance(to: pointXDireita) >= -1{

                    if dragView.translatedFrame.origin.y < viewOrigemFrame.origin.y{

                        viewsEsquerda.append(dragView)

                    }else if dragView.translatedFrame.origin.y > viewOrigemFrame.origin.y{

                        viewsDireita.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsEsquerda.count > 0{

            primeiraView = viewsEsquerda.first!
            ultimaView = currentView

        }else if viewsDireita.count > 0{

            primeiraView = currentView
            ultimaView = viewsDireita.last!

        }

        if primeiraView == ultimaView{
            return
        }

        self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x + primeiraView.translatedFrame.width, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

    }

    private func alignment_left_right(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsAcima: [UIView] = []
        var viewsAbaixo: [UIView] = []

        let listOrderY = self.otherViews.sorted { $0.translatedFrame.origin.y == $1.translatedFrame.origin.y }

        for dragView in listOrderY{

            if currentView != dragView{

                let pointXOrigem: CGFloat = viewOrigemFrame.origin.x

                let pointXDrag: CGFloat = dragView.translatedFrame.origin.x + dragView.translatedFrame.width

                if pointXOrigem.distance(to: pointXDrag) <= 1 && pointXOrigem.distance(to: pointXDrag) >= -1{

                    if dragView.translatedFrame.origin.y < viewOrigemFrame.origin.y{

                        viewsAcima.append(dragView)

                    }else if dragView.translatedFrame.origin.y > viewOrigemFrame.origin.y{

                        viewsAbaixo.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsAcima.count > 0{

            primeiraView = viewsAcima.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x + primeiraView.translatedFrame.width, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }else if viewsAbaixo.count > 0{

            primeiraView = currentView
            ultimaView = viewsAbaixo.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }

    }

    private func alignment_right_left(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsAcima: [UIView] = []
        var viewsAbaixo: [UIView] = []

        let listOrderY = self.otherViews.sorted { $0.translatedFrame.origin.y == $1.translatedFrame.origin.y }

        for dragView in listOrderY{

            if currentView != dragView{

                let pointXOrigem: CGFloat = viewOrigemFrame.origin.x + viewOrigemFrame.width

                let pointXDrag: CGFloat = dragView.translatedFrame.origin.x

                if pointXOrigem.distance(to: pointXDrag) <= 1 && pointXOrigem.distance(to: pointXDrag) >= -1{

                    if dragView.translatedFrame.origin.y < viewOrigemFrame.origin.y{

                        viewsAcima.append(dragView)

                    }else if dragView.translatedFrame.origin.y > viewOrigemFrame.origin.y{

                        viewsAbaixo.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsAcima.count > 0{

            primeiraView = viewsAcima.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }else if viewsAbaixo.count > 0{

            primeiraView = currentView
            ultimaView = viewsAbaixo.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x + primeiraView.translatedFrame.width, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }

    }

    private func alignment_top_top(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsEsquerda: [UIView] = []
        var viewsDireita: [UIView] = []

        let listOrderX = self.otherViews.sorted { $0.translatedFrame.origin.x == $1.translatedFrame.origin.x }

        for dragView in listOrderX{

            if currentView != dragView{

                if viewOrigemFrame.origin.y.distance(to: dragView.translatedFrame.origin.y) <= 1 && viewOrigemFrame.origin.y.distance(to: dragView.translatedFrame.origin.y) >= -1{

                    if dragView.translatedFrame.origin.x < viewOrigemFrame.origin.x{

                        viewsEsquerda.append(dragView)

                    }else if dragView.translatedFrame.origin.x > viewOrigemFrame.origin.x{

                        viewsDireita.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsEsquerda.count > 0{

            primeiraView = viewsEsquerda.first!
            ultimaView = currentView

        }else if viewsDireita.count > 0{

            primeiraView = currentView
            ultimaView = viewsDireita.last!

        }

        if primeiraView == ultimaView{
            return
        }

        self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y)

    }

    private func alignment_top_bot(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsEsquerda: [UIView] = []
        var viewsDireita: [UIView] = []

        let listOrderX = self.otherViews.sorted { $0.translatedFrame.origin.x == $1.translatedFrame.origin.x }

        for dragView in listOrderX{

            if currentView != dragView{

                let pointYOrigem: CGFloat = viewOrigemFrame.origin.y

                let pointYInferior: CGFloat = dragView.translatedFrame.origin.y + dragView.translatedFrame.height

                if pointYOrigem.distance(to: pointYInferior) <= 1 && pointYOrigem.distance(to: pointYInferior) >= -1{

                    if dragView.translatedFrame.origin.x < viewOrigemFrame.origin.x{

                        viewsEsquerda.append(dragView)

                    }else if dragView.translatedFrame.origin.x > viewOrigemFrame.origin.x{

                        viewsDireita.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsEsquerda.count > 0{

            primeiraView = viewsEsquerda.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y + primeiraView.translatedFrame.height, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y)

        }else if viewsDireita.count > 0{

            primeiraView = currentView
            ultimaView = viewsDireita.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }

    }

    private func alignment_bot_bot(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsEsquerda: [UIView] = []
        var viewsDireita: [UIView] = []

        let listOrderX = self.otherViews.sorted { $0.translatedFrame.origin.x == $1.translatedFrame.origin.x }

        for dragView in listOrderX{

            if currentView != dragView{

                let pointYOrigem: CGFloat = viewOrigemFrame.origin.y + viewOrigemFrame.height

                let pointYInferior: CGFloat = dragView.translatedFrame.origin.y + dragView.translatedFrame.height

                if pointYOrigem.distance(to: pointYInferior) <= 1 && pointYOrigem.distance(to: pointYInferior) >= -1{

                    if dragView.translatedFrame.origin.x < viewOrigemFrame.origin.x{

                        viewsEsquerda.append(dragView)

                    }else if dragView.translatedFrame.origin.x > viewOrigemFrame.origin.x{

                        viewsDireita.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsEsquerda.count > 0{

            primeiraView = viewsEsquerda.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y + primeiraView.translatedFrame.height, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }else if viewsDireita.count > 0{

            primeiraView = currentView
            ultimaView = viewsDireita.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y + primeiraView.translatedFrame.height, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }

    }

    private func alignment_bot_top(){

        let viewOrigemFrame = currentView.translatedFrame

        var viewsEsquerda: [UIView] = []
        var viewsDireita: [UIView] = []

        let listOrderX = self.otherViews.sorted { $0.translatedFrame.origin.x == $1.translatedFrame.origin.x }

        for dragView in listOrderX{

            if currentView != dragView{

                let pointYOrigem: CGFloat = viewOrigemFrame.origin.y + viewOrigemFrame.height

                let pointYInferior: CGFloat = dragView.translatedFrame.origin.y

                if pointYOrigem.distance(to: pointYInferior) <= 1 && pointYOrigem.distance(to: pointYInferior) >= -1{

                    if dragView.translatedFrame.origin.x < viewOrigemFrame.origin.x{

                        viewsEsquerda.append(dragView)

                    }else if dragView.translatedFrame.origin.x > viewOrigemFrame.origin.x{

                        viewsDireita.append(dragView)

                    }

                }

            }

        }

        var primeiraView = currentView!
        var ultimaView = currentView!

        if viewsEsquerda.count > 0{

            primeiraView = viewsEsquerda.first!
            ultimaView = currentView

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y + ultimaView.translatedFrame.height)

        }else if viewsDireita.count > 0{

            primeiraView = currentView
            ultimaView = viewsDireita.last!

            self.drawLine(color: lineColor, xInicio: primeiraView.translatedFrame.origin.x, yInicio: primeiraView.translatedFrame.origin.y + primeiraView.translatedFrame.height, xFim: ultimaView.translatedFrame.origin.x + ultimaView.translatedFrame.width, yFim: ultimaView.translatedFrame.origin.y)

        }

    }

    private func alignment_center_view(){

        let pointX: CGFloat = currentView.translatedFrame.origin.x + (currentView.translatedFrame.width / 2)

        let pointY: CGFloat = currentView.translatedFrame.origin.y + (currentView.translatedFrame.height / 2)

        if pointX.distance(to: parentView.center.x) <= 1 && pointX.distance(to: parentView.center.x) >= -1{

            self.drawLine(color: lineColor, xInicio: parentView.center.x, yInicio: 0, xFim: parentView.center.x, yFim: parentView.translatedFrame.height)

        }

        if pointY.distance(to: parentView.center.y) <= 1 && pointY.distance(to: parentView.center.y) >= -1{

            self.drawLine(color: lineColor, xInicio: 0, yInicio: parentView.center.y, xFim: parentView.translatedFrame.width, yFim: parentView.center.y)

        }

    }

    private func drawLine(color: UIColor, xInicio: CGFloat, yInicio: CGFloat, xFim: CGFloat, yFim: CGFloat){

        let path = UIBezierPath()
        path.lineCapStyle = .butt
        path.move(to: CGPoint(x: xInicio, y: yInicio))
        path.addLine(to: CGPoint(x: xFim, y: yFim))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = self.lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineDashPattern = [7.0,3.0]

        layersLines?.append(shapeLayer)

        self.parentView.layer.addSublayer(shapeLayer)

    }

    func clearLayersLines(){

        if layersLines != nil && layersLines!.count > 0{
            for layer in layersLines!{
                layer.removeFromSuperlayer()
            }
        }

        self.layersLines = []

    }

}
