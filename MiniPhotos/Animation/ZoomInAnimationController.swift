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
    private var indexPath: IndexPath
    
    init(cellOfInterestSnapshot: UIView, backgroundViewSnapshot: UIView, animationTransform: CGAffineTransform, indexPath: IndexPath) {
        self.cellOfInterestSnapshot = cellOfInterestSnapshot
        self.backgroundViewSnapshot = backgroundViewSnapshot
        self.animationTransform = animationTransform
        self.indexPath = indexPath
    }
 
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? MomentsViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? MomentsClusterViewController else {
            
            fatalError()
        }
        
        let containerView = transitionContext.containerView
        let startingFrame = transitionContext.initialFrame(for: fromViewController)
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        fromViewController.view.frame = startingFrame
        toViewController.view.frame = finalFrame
        
/*
        let a = containerView.subviews.count
        
        if let first = containerView.subviews.first {
            
            if first === fromViewController.view {
                print("asdfasdfs")
            }
            
        }
        
*/
        
        let reloadRequiredSections = fromViewController.reloadRequiredSections()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
            
            fromViewController.collectionView.reloadSections(reloadRequiredSections)
            toViewController.navigate(to: self.indexPath)
            fromViewController.view.alpha = 0.99
            
        }, completion: { (finished) in
            
            fromViewController.view.alpha = 1.0
            containerView.addSubview(toViewController.view)
            transitionContext.completeTransition(finished)
            
        })
        
        
    }
}
