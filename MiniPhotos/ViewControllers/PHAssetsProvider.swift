//
//  PHAssetsProvider.swift
//  TestsOnPhotosContentOffsetDecisionInCollectionView
//
//  Created by SeoGiwon on 09/12/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit
import Photos


class PHAssetsProvider {

    enum PHAssetsProviderError: Error {
        case notAuthorized
    }
    
    private(set) var allMomentsFetchResult: PHFetchResult<PHAsset>
    
    init() {
        
        // PHFetchOptions of creationDate ascending
        let creationDateFetchOption: PHFetchOptions = {
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
            return options
        }()
        
        // fetch all moments PHAssets
        let assetFetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: creationDateFetchOption)
        
        self.allMomentsFetchResult = assetFetchResult
    }
    
    func momentsClusterDataSource() -> [PHCollectionListHolder] {
        
        // fetch all moments cluster PHCollection Lists, resulting in feeding allPHCollectionLists
        let startDateFetchOption: PHFetchOptions = {
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key:"startDate", ascending: true)]
            return options
        }()
        
        let allPHCollectionLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: startDateFetchOption)
        
        
        // if allMomentsFetchResult exist, iterate over all the elements of allPHCollectionLists,
        // take each PHCollectionList and allMomentsFetchResult as parameters to produce a PHCollectionListHolder instance, resulting in producing an array of
        // PHCollectionListHolder to use it as the section, row of this collection view
        var dataSourceElements = [PHCollectionListHolder]()
        
        allPHCollectionLists.enumerateObjects({ (list, index, stop) in
            
            if let element = PHCollectionListHolder(phCollectionList: list, allPHAssets: self.allMomentsFetchResult) {
                dataSourceElements.append(element)
            }
        })
        
        return dataSourceElements
    }

    func momentsDataSource() -> [PHAssetCollectionHolder] {
        
        // fetch all moments cluster PHCollection Lists, resulting in feeding allPHCollectionLists
        let startDateFetchOption: PHFetchOptions = {
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key:"startDate", ascending: true)]
            return options
        }()
        
        let allPHAssetCollections = PHAssetCollection.fetchMoments(with: startDateFetchOption)
        
        // if allMomentsFetchResult exist, iterate over all the elements of allPHCollectionLists,
        // take each PHCollectionList and allMomentsFetchResult as parameters to produce a PHCollectionListHolder instance, resulting in producing an array of
        // PHCollectionListHolder to use it as the section, row of this collection view
        var dataSourceElements = [PHAssetCollectionHolder]()
        
        allPHAssetCollections.enumerateObjects({ (collection, index, stop) in
            
            if let element = PHAssetCollectionHolder(phAssetCollection: collection, allPHAssets: self.allMomentsFetchResult) {
                dataSourceElements.append(element)
            }
        })
        
        return dataSourceElements
    }
}
