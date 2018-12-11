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
}
