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
    private var momentsViewController: MomentsViewController?
    private var momentsClusterViewController: MomentsClusterViewController?
    var dataSourceProvider: PHAssetsProvider?
    
    func initDataSourceProvider() {
        
        self.dataSourceProvider = PHAssetsProvider()
    }
    
    func initChildViewControllers(navigationController: PhotosNavigationController) {
        self.momentsClusterViewController = navigationController.childViewControllers[0] as! MomentsClusterViewController
        self.momentsViewController = navigationController.childViewControllers[1] as! MomentsViewController
    }
    
    static func newInstanceWithMomentsViewController() -> PhotosNavigationController {
        let newInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotosNavigationController") as! PhotosNavigationController
        
        let momentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MomentsViewController") as! MomentsViewController

        newInstance.pushViewController(momentsVC, animated: false)
        
        return newInstance
    }
    
    
    
    func zoomIn(to phAsset: PHAsset) {
        // what this function does:
        // 1 check the navigation stack status and see if zooming in is possible
        // 2 If it is, navigate

        // TODO: - navigation stack validation
        guard let momentsViewController = self.momentsViewController,
            let dataSource = momentsViewController.dataSource else {
                return
        }
        
        var indexPath: IndexPath?
        for (i,v) in dataSource.enumerated() {
            
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
        self.momentsClusterViewController!.phAssetsToShowAtViewLoad = phAsset
        self.popViewController(animated: true)
        
    }
}

protocol IndexPathNavigation {
    
    func navigate(to indexPath:IndexPath)
}
