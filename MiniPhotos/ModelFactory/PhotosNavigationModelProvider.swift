//
//  PhotosNavigationModelProvider.swift
//  TestsOnPhotosContentOffsetDecisionInCollectionView
//
//  Created by SeoGiwon on 09/12/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit
import Photos


class PhotosNavigationModelProvider {

    private(set) lazy var allMomentsFetchResult: PHFetchResult<PHAsset> = {
        let creationDateFetchOption: PHFetchOptions = {
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
            return options
        }()
        
        // fetch all moments PHAssets
        let assetFetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: creationDateFetchOption)
        
        return assetFetchResult
    }()
    
    
    
    func clusterPHAssetGroups() -> [ClusterPHAssetGroup] {
        
        // fetch all moments cluster PHCollection Lists, resulting in feeding allPHCollectionLists
        let startDateFetchOption: PHFetchOptions = {
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key:"startDate", ascending: true)]
            return options
        }()
        
        let allPHCollectionLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: startDateFetchOption)
        
        
        // if allMomentsFetchResult exist, iterate over all the elements of allPHCollectionLists,
        // take each PHCollectionList and allMomentsFetchResult as parameters to produce a ClusterPHAssetGroup instance, resulting in producing an array of
        // ClusterPHAssetGroup to use it as the section, row of this collection view
        var dataSourceElements = [ClusterPHAssetGroup]()
        
        allPHCollectionLists.enumerateObjects({ (list, index, stop) in
            
            if let element = ClusterPHAssetGroup(phCollectionList: list, allPHAssets: self.allMomentsFetchResult) {
                dataSourceElements.append(element)
            }
        })
        
        return dataSourceElements
    }

    func momentsPHAssetGroups() -> [MomentsPHAssetGroup] {
        
        // fetch all moments cluster PHCollection Lists, resulting in feeding allPHCollectionLists
        let startDateFetchOption: PHFetchOptions = {
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key:"startDate", ascending: true)]
            return options
        }()
        
        let allPHAssetCollections = PHAssetCollection.fetchMoments(with: startDateFetchOption)
        
        // if allMomentsFetchResult exist, iterate over all the elements of allPHCollectionLists,
        // take each PHCollectionList and allMomentsFetchResult as parameters to produce a ClusterPHAssetGroup instance, resulting in producing an array of
        // ClusterPHAssetGroup to use it as the section, row of this collection view
        var dataSourceElements = [MomentsPHAssetGroup]()
        
        allPHAssetCollections.enumerateObjects({ (collection, index, stop) in
            
            
            var dateOfInterest: Date?
            
            var dateComponents = DateComponents.init()
            dateComponents.calendar = Calendar.current
            dateComponents.day = 1
            dateComponents.month = 11
            dateComponents.year = 2016
            dateComponents.hour = 3
            dateComponents.minute = 0
            dateComponents.second = 0
            
            dateOfInterest = Calendar.current.date(from: dateComponents)!
            
            let startDate = collection.startDate!
            
            if (startDate > dateOfInterest!) {
                
            }
            
            
            
            if let element = MomentsPHAssetGroup(phAssetCollection: collection, allPHAssets: self.allMomentsFetchResult) {
                dataSourceElements.append(element)
            }
        })
        
        return dataSourceElements
    }
}
