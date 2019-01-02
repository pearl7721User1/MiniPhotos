//
//  StringHolder.swift
//  MiniPhotos
//
//  Created by SeoGiwon on 02/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class StringHolder: PHAssetsIndexable {

    var string: String
    var phAssets: [PHAsset]
    
    init(string: String, phAssets: [PHAsset]) {
        self.phAssets = phAssets
        self.string = string
    }
}
