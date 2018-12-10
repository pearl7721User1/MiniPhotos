//
//  MomentsClusterDataSourceElement.swift
//  TestsOnPhotosContentOffsetDecisionInCollectionView
//
//  Created by GIWON1 on 2018. 11. 29..
//  Copyright © 2018년 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

struct MomentsClusterDataSourceElement {
    
    var phCollectionList: PHCollectionList
    var phAssets: [PHAsset]
    
    init?(phCollectionList: PHCollectionList, allPHAssets: PHFetchResult<PHAsset>) {
        
        guard let startDate = phCollectionList.startDate,
            let endDate = phCollectionList.endDate else {
                return nil
        }
        
        // filter
        // enumerate over fetchResult
        
        var dstPHAssets = [PHAsset]()
        
        allPHAssets.enumerateObjects({ (asset, index, stop) in
            
            if let creationDate = asset.creationDate {
                if creationDate < endDate && creationDate > startDate {
                    dstPHAssets.append(asset)
                } else if creationDate == endDate {
                    dstPHAssets.append(asset)
                }
            }
        })
        
        self.phCollectionList = phCollectionList
        self.phAssets = dstPHAssets
    }
    
}
