//
//  CubePresentAnimationController.swift
//  Pixabay
//
//  Created by Vaibhav Parmar on 26/04/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

class CubePresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var reverse: Bool = false
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext.containerView
        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let direction: CGFloat = reverse ? -1 : 1
        
        snapshot.frame = initialFrame
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(.pi)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubicPaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                //fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                snapshot.layer.transform = AnimationHelper.yRotation(0.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                snapshot.frame = finalFrame
            })
        }, completion: {_ in
            toVC.view.isHidden = false
            toVC.view.layer .transform = AnimationHelper.yRotation(0.0)
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
