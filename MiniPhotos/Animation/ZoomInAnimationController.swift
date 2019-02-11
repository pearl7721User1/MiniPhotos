//
//  MiniPlayPopupAnimationController.swift
//  WorkAround3
//
//  Created by SeoGiwon on 26/03/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit

class ZoomInPopupAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private var cellOfInterestSnapshot: UIView
    private var backgroundViewSnapshot: UIView
    private var animationTransform: CGAffineTransform
    
    init(cellOfInterestSnapshot: UIView, backgroundViewSnapshot: UIView, animationTransform: CGAffineTransform) {
        self.cellOfInterestSnapshot = cellOfInterestSnapshot
        self.backgroundViewSnapshot = backgroundViewSnapshot
        self.animationTransform = animationTransform
    }
 
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
            
            fatalError()
        }
        
        let containerView = transitionContext.containerView
        let startingFrame = transitionContext.initialFrame(for: fromViewController)
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        containerView.addSubview(backgroundViewSnapshot)
//        containerView.addSubview(cellOfInterestSnapshot)
        
        
//        backgroundViewSnapshot.frame = startingFrame
        
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
            
            self.backgroundViewSnapshot.transform = self.animationTransform
            
        }, completion: { (finished) in
            
            self.backgroundViewSnapshot.removeFromSuperview()
            
            toViewController.view.frame = finalFrame
            containerView.addSubview(toViewController.view)
            transitionContext.completeTransition(finished)
            
        })
        
        
    }
}
