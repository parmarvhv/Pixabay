//
//  SwipeInteractionController.swift
//  Pixabay
//
//  Created by Vaibhav Parmar on 27/04/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    func wireToViewController(viewController: UIViewController) {
        self.viewController = viewController
        prepareGestureRecognizerInView(view: viewController.view)
    }
    
    private func prepareGestureRecognizerInView(view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        gesture.edges = UIRectEdge.left
        //gesture.edges = UIRectEdge.all
        view.addGestureRecognizer(gesture)
    }
    
    func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        var progress = (translation.x)/200
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
        
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        case .ended:
            interactionInProgress = false
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
        default:
            break
        }
    }
}
