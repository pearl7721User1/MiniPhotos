//
//  FilteredClusterPHAssetGroup.swift
//  MiniPhotos
//
//  Created by SeoGiwon on 02/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

struct FilteredClusterPHAssetGroup: PHAssetsIndexable, PHAssetsSearchable {

    var string: String
    var phAssets: [PHAsset]
    
    init(string: String, phAssets: [PHAsset]) {
        self.phAssets = phAssets
        self.string = string
    }
    
    func nearestIndex(for phAsset: PHAsset) -> Int? {
        
        for (i,v) in self.phAssets.enumerated() {
            if phAsset == v {
                return i
            }
        }
        
        
        for (i,v) in self.phAssets.enumerated() {
            if let lvCreationDate = phAsset.creationDate,
                let rvCreationDate = v.creationDate {
                
                if lvCreationDate < rvCreationDate {
                    return i
                }
                
            }
        }
        
        return nil
    }
}
