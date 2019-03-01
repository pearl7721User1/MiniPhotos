//
//  PhotosNavigationController.swift
//  TestsOnPhotosContentOffsetDecisionInCollectionView
//
//  Created by GIWON1 on 2018. 11. 29..
//  Copyright © 2018년 SeoGiwon. All rights reserved.
//

import UIKit
import Photos


class PhotosNavigationController: UINavigationController {

    // TODO: - protocol binding for two view controllers
    private var momentsViewController: MomentsViewController!
    private var momentsClusterViewController: MomentsClusterViewController!
    var clusterPHAssetGroups: [ClusterPHAssetGroup]! {
        didSet {
            self.momentsClusterViewController.phAssetGroups = self.clusterPHAssetGroups
        }
    }
    var momentsPHAssetGroups: [MomentsPHAssetGroup]! {
        didSet {
            self.momentsViewController.phAssetGroups = self.momentsPHAssetGroups
        }
    }
    
    
    var modelProvider: PhotosNavigationModelProvider!
    
    private var zoomInAnimationController: ZoomInPopupAnimationController?
    
    
    static func newInstanceWithMomentsViewController() -> PhotosNavigationController {
        let newInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotosNavigationController") as! PhotosNavigationController
        
        let momentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MomentsViewController") as! MomentsViewController

        newInstance.pushViewController(momentsVC, animated: false)
        
        newInstance.momentsClusterViewController = (newInstance.childViewControllers[0] as! MomentsClusterViewController)
        newInstance.momentsViewController = (newInstance.childViewControllers[1] as! MomentsViewController)
        
        newInstance.delegate = newInstance
        
        return newInstance
    }
    
    
    
    func zoomIn(to phAsset: PHAsset, originFromVisibleContent: CGPoint) {
        // what this function does:
        // 1 check the navigation stack status and see if zooming in is possible
        // 2 If it is, navigate
        
        if momentsViewController != nil {
            print("asdfsdf")
        }
        

        let destinationIndexPath = momentsViewController.indexPath(containing: phAsset)
        let referenceIndexPath = momentsClusterViewController.indexPath(containing: phAsset)
        
        if let indexPathNavigatiable = momentsViewController as? IndexPathNavigation,
            let destinationIndexPath = destinationIndexPath,
            let referenceIndexPath = referenceIndexPath {
            
            indexPathNavigatiable.navigate(to: destinationIndexPath, originFromVisibleContent:originFromVisibleContent)
            
            // get disappearing indexpaths
            let excludedPHAssets = momentsViewController.visiblePHAssets()
            let disappearingIndexPaths = momentsClusterViewController.visibleIndexPaths(excluding: excludedPHAssets)
            let transitionInfo = indexPathTransitionInfo(indexPaths: disappearingIndexPaths, refIndexPath: referenceIndexPath)
            momentsClusterViewController.setDisappearingTransitionInfo(info: transitionInfo)
            
            
            // animation transform for background
            let bgView = momentsClusterViewController.collectionView.snapshotView(afterScreenUpdates: true) ?? UIView()

            self.zoomInAnimationController = ZoomInPopupAnimationController(cellOfInterestSnapshot: UIView(), backgroundViewSnapshot:bgView, animationTransform: CGAffineTransform.identity, indexPath:destinationIndexPath)
            
        }
        
        
        self.pushViewController(momentsViewController, animated: true)
    
    }
    
    func zoomOut(to phAsset: PHAsset?) {
        // what this function does:
        // 0 simply pop view controller if phAsset is nil
        // 1 check the navigation stack status and see if zooming out is possible
        // 2 if it is, find the indexPath
        // 3

        // plant indexPathToShowAtViewLoad
//        self.momentsClusterViewController!.phAssetsToShowAtViewLoad = phAsset
        self.popViewController(animated: true)
        
    }
    
    private func indexPathTransitionInfo(indexPaths:[IndexPath], refIndexPath:IndexPath) -> IndexPathTransitionInfo {
        
        var refRect: CGRect {
            if let attributeItem = momentsClusterViewController.collectionView.collectionViewLayout.layoutAttributesForItem(at: refIndexPath) {
                return attributeItem.frame
            } else {
                return CGRect.zero
            }
        }
        
        var info = IndexPathTransitionInfo()
        
        for (i,v) in indexPaths.enumerated() {
            if let item = momentsClusterViewController.collectionView.collectionViewLayout.layoutAttributesForItem(at: v) {
                
                let vector = reverseVector(boundary: momentsClusterViewController.collectionView.bounds, startingRect: item.frame, refRect: refRect)
                
                info.add(indexPath: v, vector: vector)
            }
        }
        
        return info
    }
    
    private func reverseVector(boundary:CGRect, startingRect:CGRect, refRect:CGRect) -> GiwonVector {
        
        let calculator = VectorCalculator(boundaryRect: boundary)
        let pointer = CGPoint(x:startingRect.midX - refRect.midX, y:startingRect.midY - refRect.midY)
        
        let vector = calculator.vectorForReachingBoundary(lengthOfOneStep: 10, pointer: pointer, from: CGPoint(x: startingRect.midX, y: startingRect.midY))
        return vector
    }
    
    private func animationTransform(startingFrame: CGRect, destinationPoint: CGPoint, scale:CGSize) -> CGAffineTransform {
        
        let scaleTransform = CGAffineTransform(scaleX: scale.width, y: scale.height)
        
        let offset = CGPoint(x: (startingFrame.size.width * scale.width - startingFrame.size.width) / 2.0, y: (startingFrame.size.height * scale.height - startingFrame.size.height) / 2.0)
        
//        let translateTransform = CGAffineTransform(translationX: destinationPoint.x + startingFrame.origin.x + offset.x, y: destinationPoint.y + startingFrame.origin.y + offset.y)
        
        let translateTransform = CGAffineTransform(translationX: startingFrame.origin.x + offset.x, y: startingFrame.origin.y + offset.y - 64 - 50)
        
        let animationTransform = scaleTransform.concatenating(translateTransform)
        
        return animationTransform
    }
}

extension PhotosNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return self.zoomInAnimationController
        }
        
        return nil
    }
}

protocol IndexPathNavigation {
    
    func navigate(to indexPath:IndexPath, originFromVisibleContent:CGPoint)
    
}
