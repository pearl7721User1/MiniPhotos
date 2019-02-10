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
    
    static func newInstanceWithMomentsViewController() -> PhotosNavigationController {
        let newInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotosNavigationController") as! PhotosNavigationController
        
        let momentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MomentsViewController") as! MomentsViewController

        newInstance.pushViewController(momentsVC, animated: false)
        
        newInstance.momentsClusterViewController = (newInstance.childViewControllers[0] as! MomentsClusterViewController)
        newInstance.momentsViewController = (newInstance.childViewControllers[1] as! MomentsViewController)
        
        return newInstance
    }
    
    
    
    func zoomIn(to phAsset: PHAsset) {
        // what this function does:
        // 1 check the navigation stack status and see if zooming in is possible
        // 2 If it is, navigate

        var indexPath: IndexPath?
        for (i,v) in momentsPHAssetGroups.enumerated() {
            
            for (j,w) in v.phAssets.enumerated() {
                if phAsset.isEqual(w) {
                    indexPath = IndexPath(item: j, section: i)
                }
            }
        }
    
        if let indexPathNavigatiable = momentsViewController as? IndexPathNavigation,
            let indexPath = indexPath {
            
            indexPathNavigatiable.navigate(to: indexPath)
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
}

protocol IndexPathNavigation {
    
    func navigate(to indexPath:IndexPath)
}
