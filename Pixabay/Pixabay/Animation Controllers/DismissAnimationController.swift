//
//  DismissAnimationController.swift
//  Pixabay
//
//  Created by Vaibhav Parmar on 25/04/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var destinationFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext.containerView
        let initialFrame = transitionContext.initialFrame(for: fromVC)
        let finalFrame = destinationFrame
        
        snapshot.frame = initialFrame
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        fromVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        toVC.view.layer.transform = AnimationHelper.yRotation(-.pi/2)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubicPaced , animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                snapshot.frame = finalFrame
            })
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                snapshot.layer.transform = AnimationHelper.yRotation(.pi/2)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                //snapshot.frame = finalFrame
                toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
            })
        }, completion: { _ in
            fromVC.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
