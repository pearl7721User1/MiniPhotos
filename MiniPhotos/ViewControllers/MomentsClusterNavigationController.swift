//
//  MomentsClusterNavigationController.swift
//  TestsOnPhotosContentOffsetDecisionInCollectionView
//
//  Created by GIWON1 on 2018. 11. 29..
//  Copyright © 2018년 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class MomentsClusterNavigationController: UINavigationController {

    private var momentsViewController: MomentsViewController?
    var dataSourceProvider: PHAssetsProvider?
    
    func initDataSourceProvider() {
        
        self.dataSourceProvider = PHAssetsProvider()
    }
    
    static func newInstanceWithMomentsViewController() -> MomentsClusterNavigationController {
        let newInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MomentsClusterNavigationController") as! MomentsClusterNavigationController
        
        let momentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MomentsViewController") as! MomentsViewController

        newInstance.pushViewController(momentsVC, animated: false)
        
        return newInstance
    }
    
    func zoomIn(from momentsClusterViewController: MomentsClusterViewController, to phAsset: PHAsset) {
        
        if let momentsViewController = self.momentsViewController {
            
            var indexPath: IndexPath?
            if let dataSource = momentsViewController.dataSource {
                
                for (i,v) in dataSource.enumerated() {
                    
                    for (j,w) in v.phAssets.enumerated() {
                        if phAsset.isEqual(w) {
                            indexPath = IndexPath(item: j, section: i)
                        }
                    }
                }
            }
            
            if let indexPathNavigatiable = momentsViewController as? IndexPathNavigation,
                let indexPath = indexPath {
                
                indexPathNavigatiable.navigate(to: indexPath)
            }
            
            self.pushViewController(momentsViewController, animated: true)
        }
    }
    
    func zoomOut(from momentsViewController: MomentsViewController, to phAsset: PHAsset?) {
        self.momentsViewController = self.popViewController(animated: true) as? MomentsViewController
        
    }
}

protocol IndexPathNavigation {
    
    func navigate(to indexPath:IndexPath)
}
