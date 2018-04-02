import Foundation
import UIKit


public class KeyboardView: UIView{
    var keys: [[String]] = [
        [ "`","1","2","3","4","5","6","7","8","9","0","-","="],
        ["q","w","e","r","t","y","u","i","o","p","[","]","\\"],
        ["a","s","d","f","g","h","j","k","l",";","'"],
        ["z","x","c","v","b","n","m",",",".","/"]]


    //var inputField: UITextField!
    var primaryStack: UIStackView!
    var buttons: [UIButton]!
    var spaceButton: UIButton!
    var deleteButton: UIButton!

    public weak var inputField: UITextField!
    public var didChangeText: ((UITextField)->Void)?

    convenience public init(inputField: UITextField) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: 500.0, height: 250.0))
        self.inputField = inputField
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(){
        setupButtons()
        primaryStack = UIStackView()
        primaryStack.spacing = 2.0
        addSubview(primaryStack)

        let row1size = keys[0].count
        let row2size = keys[1].count
        let row3size = keys[2].count
        let row4size = keys[3].count

        //setup first stack
        let firstStack = UIStackView()
        firstStack.spacing = 2.0
        firstStack.axis = .horizontal
        for i in 0..<row1size{
            firstStack.addArrangedSubview(buttons[i])
            if firstStack.arrangedSubviews.count > 1 {
                firstStack.arrangedSubviews.last!.widthAnchor.constraint(equalTo: firstStack.arrangedSubviews[0].widthAnchor, multiplier: 1.0).isActive = true
            }
        }
        deleteButton = createGenericButton()
        deleteButton.setTitle("←",for: [])
        deleteButton.addTarget(self, action: #selector(didEndDelete(sender:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete(sender:)), for: .touchDown)

        firstStack.addArrangedSubview(deleteButton)
        firstStack.arrangedSubviews.first?.widthAnchor.constraint(equalTo: firstStack.widthAnchor, multiplier: 0.07).isActive = true

        //setup second stack
        let secondStack = UIStackView()
        secondStack.spacing = 2.0
        secondStack.axis = .horizontal
        secondStack.addArrangedSubview(ButtonLikeView())
        for i in row1size..<(row1size+row2size){
            secondStack.addArrangedSubview(buttons[i])
            if secondStack.arrangedSubviews.count > 2 {
                secondStack.arrangedSubviews.last!.widthAnchor.constraint(equalTo: secondStack.arrangedSubviews[1].widthAnchor, multiplier: 1.0).isActive = true
            }
        }
        secondStack.arrangedSubviews[1].widthAnchor.constraint(equalTo: secondStack.widthAnchor, multiplier: 0.07).isActive = true

        //setup third stack
        let thirdStack = UIStackView()
        thirdStack.spacing = 2.0
        thirdStack.axis = .horizontal
        thirdStack.addArrangedSubview(ButtonLikeView())
        for i in (row1size + row2size)..<(row1size+row2size+row3size){
            thirdStack.addArrangedSubview(buttons[i])
            if thirdStack.arrangedSubviews.count > 2 {
                thirdStack.arrangedSubviews.last!.widthAnchor.constraint(equalTo: thirdStack.arrangedSubviews[1].widthAnchor, multiplier: 1.0).isActive = true
            }
        }
        thirdStack.addArrangedSubview(ButtonLikeView())
        thirdStack.arrangedSubviews[1].widthAnchor.constraint(equalTo: thirdStack.widthAnchor, multiplier: 0.07).isActive = true
        thirdStack.arrangedSubviews.last?.widthAnchor.constraint(equalTo: thirdStack.arrangedSubviews[0].widthAnchor, multiplier: 1.0).isActive = true

        //setup forth stack
        let forthStack = UIStackView()
        forthStack.spacing = 2.0
        forthStack.axis = .horizontal
        let capsButton = createGenericButton()
        capsButton.setTitle("CAPS",for: [])
        capsButton.addTarget(self, action: #selector(didTapUpperCase(sender:)), for: .touchUpInside)
        forthStack.addArrangedSubview(capsButton)
        for i in (row1size + row2size + row3size)..<(row1size+row2size+row3size+row4size){
            forthStack.addArrangedSubview(buttons[i])
            if forthStack.arrangedSubviews.count > 2 {
                forthStack.arrangedSubviews.last!.widthAnchor.constraint(equalTo: forthStack.arrangedSubviews[1].widthAnchor, multiplier: 1.0).isActive = true
            }
        }
        forthStack.addArrangedSubview(ButtonLikeView())
        forthStack.arrangedSubviews[1].widthAnchor.constraint(equalTo: forthStack.widthAnchor, multiplier: 0.07).isActive = true
        forthStack.arrangedSubviews.last?.widthAnchor.constraint(equalTo: forthStack.arrangedSubviews[0].widthAnchor, multiplier: 1.0).isActive = true

        //setup fifth stack
        let fifthStack = UIStackView()
        fifthStack.spacing = 2.0
        spaceButton = createGenericButton()
        spaceButton.addTarget(self, action: #selector(didTapSpace(sender:)), for: .touchUpInside)
        fifthStack.axis = .horizontal
        fifthStack.addArrangedSubview(UIView())         //0
        fifthStack.addArrangedSubview(ButtonLikeView()) //1
        fifthStack.addArrangedSubview(ButtonLikeView()) //2
        fifthStack.addArrangedSubview(spaceButton)      //3
        fifthStack.addArrangedSubview(ButtonLikeView()) //4
        fifthStack.addArrangedSubview(ButtonLikeView()) //5
        fifthStack.addArrangedSubview(UIView())         //6

        fifthStack.arrangedSubviews[0].widthAnchor.constraint(equalTo: fifthStack.arrangedSubviews[1].widthAnchor, multiplier: 1.0).isActive = true
        fifthStack.arrangedSubviews[0].widthAnchor.constraint(equalTo: fifthStack.widthAnchor, multiplier: 0.07).isActive = true
        fifthStack.arrangedSubviews[0].widthAnchor.constraint(equalTo: fifthStack.arrangedSubviews[6].widthAnchor, multiplier: 1.0).isActive = true
        fifthStack.arrangedSubviews[1].widthAnchor.constraint(equalTo: fifthStack.arrangedSubviews[5].widthAnchor, multiplier: 1.0).isActive = true
        fifthStack.arrangedSubviews[2].widthAnchor.constraint(equalTo: fifthStack.arrangedSubviews[4].widthAnchor, multiplier: 1.0).isActive = true
        fifthStack.arrangedSubviews[3].widthAnchor.constraint(equalTo: fifthStack.widthAnchor, multiplier: 0.5).isActive = true

        //setup primary stack
        primaryStack.axis = .vertical
        primaryStack.distribution = .fillEqually
        primaryStack.addArrangedSubview(firstStack)
        primaryStack.addArrangedSubview(secondStack)
        primaryStack.addArrangedSubview(thirdStack)
        primaryStack.addArrangedSubview(forthStack)
        primaryStack.addArrangedSubview(fifthStack)

        primaryStack.translatesAutoresizingMaskIntoConstraints = false
        primaryStack.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        primaryStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        primaryStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
        primaryStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true

        backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    }

    @objc
    func didTapKey(sender: UIButton){
        inputField.text = "\(inputField.text!)\(sender.titleLabel!.text!)"
        didChangeText?(inputField)
    }



    var timer: Timer?
    var deleteRate: Int = 0

    @objc
    func didTapDelete(sender: UIButton){
        //touch inside
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            self.deleteRate += 1
            if self.inputField.text?.count == 0 {
                timer.invalidate()
                return
            }
            var text: String = self.inputField.text!
            text.removeLast()
            self.inputField.text = text
            self.didChangeText?(self.inputField)
        }
        timer?.fire()
    }

    @objc
    func didEndDelete(sender: UIButton){
        //touch up inside
        timer?.invalidate()

    }

    @objc
    func didTapSpace(sender: UIButton){
        inputField.text = "\(inputField.text!) "
        didChangeText?(inputField)
    }

    @objc
    func didTapUpperCase(sender: UIButton){
        sender.isSelected = !sender.isSelected
        changeCase(in: primaryStack,toUpperCase: sender.isSelected)
    }

    func changeCase(in view: UIView,toUpperCase upper: Bool = true){
        if view is UIButton {
            let btn = view as! UIButton
            let title = btn.title(for: []) ?? ""
            btn.setTitle((upper ? title.uppercased() : title.lowercased()),for: [])
            return
        }
        for sub in view.subviews {
            changeCase(in: sub,toUpperCase: upper)
        }
    }

    @objc
    func setupButtons(){
        buttons = [UIButton]()
        for array in keys{
            for char in array{
                let button = createGenericButton()
                button.setTitle("\(char)", for: [])
                buttons.append(button)
                button.addTarget(self, action: #selector(didTapKey(sender:)), for: .touchUpInside)
            }
        }
    }

    func createGenericButton()->UIButton{
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.setBackgroundImage(UIImage(color: .white),for: [])
        button.setBackgroundImage(UIImage(color: .lightGray),for: .highlighted)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        //button.titleLabel?.font = SystemSettings.normalSizeFont
        return button
    }

    class ButtonLikeView: UIView{

        convenience init(){
            self.init(frame: CGRect.zero)
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        func setup(){
            self.backgroundColor = .clear
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }


    }

    var lastCharCount = 0

    func buttonForText(_ text: String)->UIButton?{

        var count: Int = 0
        for array in keys{
            for item in array{
                if item == text{
                    return buttons[count]
                }
                count += 1
            }
        }
        return nil
    }

    let textChangeAnimationDuration: TimeInterval = 0.7

}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
