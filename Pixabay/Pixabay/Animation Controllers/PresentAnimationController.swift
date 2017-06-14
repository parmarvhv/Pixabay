//
//  PresentAnimationController.swift
//  Pixabay
//
//  Created by Vaibhav Parmar on 25/04/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

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
        
        snapshot.frame = initialFrame
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        //snapshot.layer.transform = AnimationHelper.yRotation(.pi/3) 
        fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi/2)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                    fromVC.view.layer.transform = AnimationHelper.yRotation(.pi/2)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
//                    snapshot.layer.transform = AnimationHelper.yRotation(0.0)
                    fromVC.view.layer.transform = AnimationHelper.yRotation(.pi/2)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                    snapshot.frame = finalFrame
                })
        },
            completion: { _ in
                // 5
                toVC.view.isHidden = false
                fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
        
//        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubicPaced, animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
//                fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
//            })
//            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
//                snapshot.layer.transform = AnimationHelper.yRotation(-.pi)
//            })
//            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
//                snapshot.frame = finalFrame
//            })
//            
//        }, completion: { _ in
//            toVC.view.isHidden = false
//            fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
//            snapshot.removeFromSuperview()
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        })
        
        
    }
    
}
