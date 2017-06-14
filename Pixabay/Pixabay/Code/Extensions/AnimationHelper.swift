//
//  File.swift
//  Pixabay
//
//  Created by Vaibhav Parmar on 25/04/17.
//  Copyright © 2017 Nickelfox. All rights reserved.
//

import UIKit

struct AnimationHelper {
    
    static func zRotation(_ angle: Double) -> CASpringAnimation {
        let springRotation = CASpringAnimation(keyPath: "transform.rotation.z")
        springRotation.toValue = Int(angle)
        return springRotation
    }
    
    static func yRotation(_ angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    static func perspectiveTransformForContainerView(_ containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.001
        containerView.layer.sublayerTransform = transform
    }
}
