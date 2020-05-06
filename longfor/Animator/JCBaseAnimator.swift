//
//  JCBaseAnimator.swift
//  longfor
//
//  Created by jack on 2020/5/6.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class JCBaseAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    static var animator:JCBaseAnimator?
    var op:UINavigationController.Operation = UINavigationController.Operation.none
    var pdit:UIPercentDrivenInteractiveTransition? = nil
    var pan:UIPanGestureRecognizer? = nil
    var nc:UINavigationController? = nil
    var vc:UIViewController? = nil
    var duration:TimeInterval
    var boundary:CGFloat
    var progress:CGFloat = 0
    var target:Any? = nil
    
    override init() {
        duration = 0.3
        boundary = 0.5
        super.init()
        JCBaseAnimator.animator = self
    }
    
    func setTarget(value:Any?) {
        if let target = value as? UINavigationController
        {
            nc = target
            nc?.delegate = self
            pan?.isEnabled = nc != nil
        }
        else if let target = value as? UIViewController
        {
            vc = target
            vc?.transitioningDelegate = self
        }
    }
    
    func setDuration(value:TimeInterval) {
        duration = value > 0 ? value : duration
    }
    
    func setPan(value:UIPanGestureRecognizer?) {
        pan = value
        pan?.delegate = self
        pdit = UIPercentDrivenInteractiveTransition()
        pan?.addTarget(self, action: #selector(panFromView))
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func panFromView() {
        if pan!.state == UIGestureRecognizer.State.changed
        {
            pdit!.update(progress)
        }
        else if pan!.state != UIGestureRecognizer.State.began
        {
            if pdit!.percentComplete < boundary
            {
                pdit!.cancel()
            }
            else
            {
                pdit!.finish()
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        JCBaseAnimator.animator = nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        op = UINavigationController.Operation.push
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        op = UINavigationController.Operation.pop
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        op = operation
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return pdit
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !animated
        {
            JCBaseAnimator.animator = nil
        }
    }
    
    deinit {
        print("Animator deinit")
        vc?.transitioningDelegate = nil
        nc?.delegate = nil
        nc = nil
        vc = nil
    }
    
}
