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
    
    init(phCollectionList: PHCollectionList, phAssets: [PHAsset]) {
        self.phCollectionList = phCollectionList
        self.phAssets = phAssets
    }
    
    static func filteredMomentsClusterDataSourceElement(element: MomentsClusterDataSourceElement) -> MomentsClusterDataSourceElement {
        
        let dstPHCollectionList = element.phCollectionList
        var dstPHAssets: [PHAsset]!
        
        if element.phAssets.count > 50 {
            dstPHAssets = reduce(from: element.phAssets, dstSize: 50)
        } else if element.phAssets.count > 40 {
            dstPHAssets = reduce(from: element.phAssets, dstSize: 40)
        } else if element.phAssets.count > 30 {
            dstPHAssets = reduce(from: element.phAssets, dstSize: 30)
        } else if element.phAssets.count > 20 {
            dstPHAssets = reduce(from: element.phAssets, dstSize: 20)
        } else if element.phAssets.count > 10 {
            dstPHAssets = reduce(from: element.phAssets, dstSize: 10)
        } else {
            dstPHAssets = element.phAssets
        }
        
        let element = MomentsClusterDataSourceElement(phCollectionList: dstPHCollectionList, phAssets: dstPHAssets)
        
        return element
    }
    
    static private func reduce(from srcArray: [PHAsset], dstSize: Int) -> [PHAsset] {
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
