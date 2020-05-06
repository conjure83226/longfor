//
//  JCAnimatorAlphaAndScale.swift
//  longfor
//
//  Created by jack on 2020/5/6.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class JCAnimatorAlphaAndScale: JCBaseAnimator {
    
    var alpha:CGFloat
    var scale:CGFloat
    
    class func animator(target:Any?, animated:Bool) -> Bool {
        if animated {
            let animator:JCAnimatorAlphaAndScale = JCAnimatorAlphaAndScale()
            animator.setTarget(value: target)
            animator.duration = 0.35
            return true
        }
        return false
    }
    
    override init() {
        alpha = 0
        scale = 1.5
        super.init()
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        var toAlpha:CGFloat = 1
        var toTransform:CGAffineTransform = CGAffineTransform.identity
        var toView:UIView! = transitionContext.view(forKey: UITransitionContextViewKey.to)
        if (self.op == UINavigationController.Operation.push)
        {
            transitionContext.containerView.addSubview(toView)
            toView.transform = CGAffineTransform(scaleX: scale, y: scale)
            toView.alpha = alpha
        }
        else
        {
            transitionContext.containerView.insertSubview(toView, at: 0)
            toView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            toTransform = CGAffineTransform(scaleX: scale, y: scale);
            toAlpha = alpha
        }
        UIView.animate(withDuration: self.duration, animations: {
            toView.transform = toTransform
            toView.alpha = toAlpha
        }) { (Bool) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
