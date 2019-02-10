//
//  ClusterPHAssetGroup.swift
//  TestsOnPhotosContentOffsetDecisionInCollectionView
//
//  Created by GIWON1 on 2018. 11. 29..
//  Copyright © 2018년 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

struct ClusterPHAssetGroup: PHAssetsIndexable {

    var phAssets: [PHAsset]
    var phCollectionList: PHCollectionList
    
    init?(phCollectionList: PHCollectionList, allPHAssets: PHFetchResult<PHAsset>) {
        
        guard let startDate = phCollectionList.startDate,
            let endDate = phCollectionList.endDate else {
                print("moments cluster nil")
                return nil
        }
        
        // filter
        // enumerate over fetchResult
        
        var dstPHAssets = [PHAsset]()
        
        allPHAssets.enumerateObjects({ (asset, index, stop) in
            
            if let creationDate = asset.creationDate {
                if creationDate < endDate && creationDate > startDate {
                    dstPHAssets.append(asset)
                } else if creationDate == endDate || creationDate == startDate {
                    dstPHAssets.append(asset)
                }
            } else {
                print("creationDate doesn't exist")
            }
        })
        
        self.phCollectionList = phCollectionList
        self.phAssets = dstPHAssets
    }
    
    func filteredClusterPHAssetGroup() -> FilteredClusterPHAssetGroup {
        
        let dstPHCollectionList = self.phCollectionList
        var dstPHAssets: [PHAsset]!
        
        if self.phAssets.count > 50 {
            dstPHAssets = reduce(from: self.phAssets, dstSize: 50)
        } else if self.phAssets.count > 40 {
            dstPHAssets = reduce(from: self.phAssets, dstSize: 40)
        } else if self.phAssets.count > 30 {
            dstPHAssets = reduce(from: self.phAssets, dstSize: 30)
        } else if self.phAssets.count > 20 {
            dstPHAssets = reduce(from: self.phAssets, dstSize: 20)
        } else if self.phAssets.count > 10 {
            dstPHAssets = reduce(from: self.phAssets, dstSize: 10)
        } else {
            dstPHAssets = self.phAssets
        }
        
        // create a FilteredClusterPHAssetGroup
        var title = ""
        if let startDate = dstPHCollectionList.startDate,
            let endDate = dstPHCollectionList.endDate {
            
            let f = DateFormatter()
            f.dateStyle = .medium
            f.timeStyle = .medium
            
            title = "\(f.string(from: startDate)) - \(f.string(from:endDate))"
        }
        
        let filteredClusterPHAssetGroup = FilteredClusterPHAssetGroup(string: title, phAssets: dstPHAssets)
        return filteredClusterPHAssetGroup
    }
    
    private func reduce(from srcArray: [PHAsset], dstSize: Int) -> [PHAsset] {
        let stride: Double = Double(srcArray.count) / Double((dstSize))
        
        var indexesOfSelection = [Int]()
        indexesOfSelection.append(0)
        
        var workingIndex: Double = 0
        
        for _ in 1..<dstSize {
            
            workingIndex += stride
            indexesOfSelection.append((Int)(workingIndex))
        }
        
        var dstArray = [PHAsset]()
        for i in indexesOfSelection {
            dstArray.append(srcArray[i])
        }
        
        return dstArray
    }
    
}
