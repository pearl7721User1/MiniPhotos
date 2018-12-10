//
//  MomentsDataSourceElement.swift
//  TestsOnPhotosContentOffsetDecisionInCollectionView
//
//  Created by SeoGiwon on 09/12/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class MomentsDataSourceElement {

    var phAssetCollection: PHAssetCollection
    var phAssets: [PHAsset]
    
    init?(phAssetCollection: PHAssetCollection, allPHAssets: PHFetchResult<PHAsset>) {
        
        guard let startDate = phAssetCollection.startDate,
            let endDate = phAssetCollection.endDate else {
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
        
        self.phAssetCollection = phAssetCollection
        self.phAssets = dstPHAssets
    }
    
}
