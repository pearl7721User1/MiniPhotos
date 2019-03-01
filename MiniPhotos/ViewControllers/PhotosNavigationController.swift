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

        var endingIndexPath: IndexPath?
        for (i,v) in momentsPHAssetGroups.enumerated() {
            
            for (j,w) in v.phAssets.enumerated() {
                if phAsset.isEqual(w) {
                    endingIndexPath = IndexPath(item: j, section: i)
                }
            }
        }
    
        if let indexPathNavigatiable = momentsViewController as? IndexPathNavigation,
            let endingIndexPath = endingIndexPath {
            
            
            indexPathNavigatiable.navigate(to: endingIndexPath, originFromVisibleContent:originFromVisibleContent)
            /*
            // animation transform for cell
            let startingFrameForCell = momentsClusterViewController.collectionView.contentOffsetRect(for: startingIndexPath)
            let endingFrameForCell = momentsViewController.collectionView.contentOffsetRect(for: endingIndexPath)
            
            let scaleFactor = CGSize(width: endingFrameForCell.size.width / startingFrameForCell.size.width, height: endingFrameForCell.size.height / startingFrameForCell.size.height)
            
            let animationTransformForCell = animationTransform(startingFrame: startingFrameForCell, destinationPoint: endingFrameForCell.origin, scale: scaleFactor)
            */
            
            
            /*
            let scaleTransform = CGAffineTransform(scaleX: scaleFactor.width, y: scaleFactor.height)
            
            let offset = CGPoint(x: (startingFrame.size.width * scaleFactor.width - startingFrame.size.width) / 2.0, y: (startingFrame.size.height * scaleFactor.height - startingFrame.size.height) / 2.0)
            
            let translateTransform = CGAffineTransform(translationX: endingFrame.origin.x - startingFrame.origin.x + offset.x, y: endingFrame.origin.y - startingFrame.origin.y + offset.y)
            
            let animationTransform = scaleTransform.concatenating(translateTransform)
            */
            
            // animation transform for background
            let bgView = momentsClusterViewController.collectionView.snapshotView(afterScreenUpdates: true) ?? UIView()
//            bgView.backgroundColor = UIColor.green
//            bgView.frame = momentsClusterViewController.collectionView.contentOffsetRect(for: startingIndexPath)
            
            // CGSize.init(width: 2, height: 2)
//           let animationTransformForBg = animationTransform(startingFrame: bgView.frame, destinationPoint: endingFrameForCell.origin, scale:scaleFactor )
//            print("\(bgView.frame.origin.x), \(bgView.frame.origin.y), \(bgView.frame.size.width), \(bgView.frame.size.height)")
            
            self.zoomInAnimationController = ZoomInPopupAnimationController(cellOfInterestSnapshot: UIView(), backgroundViewSnapshot:bgView, animationTransform: CGAffineTransform.identity, indexPath:endingIndexPath)
            
//            momentsViewController.collectionView.contentOffsetRect(for: endingIndexPath)
            
        }
        
        // reload sections
        //momentsClusterViewController.reloadRequiredSections()
        
        self.pushViewController(momentsViewController, animated: false)
    
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
