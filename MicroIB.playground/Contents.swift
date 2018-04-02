/*:

 # Micro Interface Builder
 ### A lightweight Interface Builder

 Created By [Antonio Zaitoun](https://github.com/minitour)


 ## Idea and Concept
 Ever since Playgrounds have been introduced back in WWDC 2014 we've seen many tutorials revolving around Swift and what we can do with it, However we have never really dug into iOS's interface development tools. With that being said, I decided to make my playground all about the Interface Builder tool that has been around in Xcode ever since we can remember.

 ## The Architecture and Infrastructure
 The project is separated into four main parts:

 ### The Component View

 The component view is a tool bar that consists a list of views/components that can be used to to design the interface with on the canvas view. Since all components are a subclass of UIView they share a list of common properties, However, each component has it's own unique set of properties. These properties are called "Inspectables" and they can be viewed and edited using The Property Inspector.

 ### The Property Inspector

 Is a tool bar that can be found on the top-part of the layout. It displays the inspectable fields of the selected element component. It consists of properties such as `String`, `Int`, `Float`, `Precent` (0~100), `Boolean`, `Color`, `Image` and `Auto Resizing Mask`.


 ### The Canvas View

 It is the main view which accepts the drops from the component view and the view on which we design the the layout. Once a drop transaction has been accepted by the canvas view, The canvas automatically converts the component into a `DraggableView` and sets it's `contentView` property using the `ComponentDataSource` class which is in charge of providing all the components and their implementation. The canvas always keeps track of the draggable views in order to manage them, as well as converting it-self into a renderable view recursively in order to be inspected using the 3D Hierarchy Inspector.

 ### The 3D Hierarchy Inspector

 Built using SceneKit, It is the view which displays our layout in a 3 dimensional interactive presentation.
 The way it works, is it takes all of the views inside the Canvas View and then recursively renders the views on top of each other on the Z axis.

 - note:
Both the `Component View` and the `Property Inspector` are horizontally scrollable.

 */

//#-hidden-code
import UIKit
import PlaygroundSupport



let width: CGFloat = 600.0
let height: CGFloat = 800.0
let canvasHolderSize: CGFloat = 1000.0



//setup main scene
let mainView = UIView()
mainView.frame = CGRect(x: 0, y: 0, width: width, height: height)

//setup component view
let compView = ComponentMenu()
mainView.addSubview(compView)


let canvasHolder = CanvasHolder()
mainView.addSubview(canvasHolder)


let appearanceCustomizeView = AppearanceCustomizeView()
mainView.addSubview(appearanceCustomizeView)


canvasHolder.canvas?.focusChanged = { canvas in
    if let id = canvas.focusId {
        appearanceCustomizeView.draggableView = canvas.draggableViews[id]
    }else{
        appearanceCustomizeView.draggableView = nil
    }
}
var didShowHintForInspector: Bool = false
appearanceCustomizeView.canvasView = canvasHolder.canvas
appearanceCustomizeView.onViewHeirarchyClicked = { btn in
    let ibh = IBHeirarchyView(frame: mainView.bounds)
    ibh.onDismissClicked = {
        UIView.animate(withDuration: 0.2, animations: {
            ibh.frame.origin.x -= 50.0
            ibh.alpha = 0.0
        }) { comp in
            ibh.removeFromSuperview()
        }

    }
    mainView.addSubview(ibh)
    ibh.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    ibh.frame = mainView.frame
    ibh.frame.origin.x -= 50.0
    ibh.alpha = 0.0
    ibh.set(view: canvasHolder.canvas.dummyView)
    UIView.animate(withDuration: 0.2) {
        ibh.alpha = 1.0
        ibh.frame = mainView.frame
    }

    if !didShowHintForInspector {
        ibh.showMessage("Hold And Drag To Inspect",withDelay: 1.0)
        didShowHintForInspector = true
    }

}

//setup auto layout
compView.translatesAutoresizingMaskIntoConstraints = false
canvasHolder.translatesAutoresizingMaskIntoConstraints = false
appearanceCustomizeView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate(
    [
        compView.leftAnchor.constraint(equalTo: mainView.leftAnchor),
        compView.rightAnchor.constraint(equalTo: mainView.rightAnchor),
        compView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
        compView.heightAnchor.constraint(equalToConstant: 96.0),
        canvasHolder.bottomAnchor.constraint(equalTo: compView.topAnchor),
        canvasHolder.leftAnchor.constraint(equalTo: mainView.leftAnchor),
        canvasHolder.rightAnchor.constraint(equalTo: mainView.rightAnchor),
        canvasHolder.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.7),
        appearanceCustomizeView.topAnchor.constraint(equalTo: mainView.topAnchor),
        appearanceCustomizeView.leftAnchor.constraint(equalTo: mainView.leftAnchor),
        appearanceCustomizeView.rightAnchor.constraint(equalTo: mainView.rightAnchor),
        appearanceCustomizeView.heightAnchor.constraint(equalToConstant: 144.0)
    ])

mainView.heightAnchor.constraint(equalToConstant: height).isActive = true

//set live
PlaygroundPage.current.liveView =  mainView
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code
