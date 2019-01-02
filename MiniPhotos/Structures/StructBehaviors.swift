//
//  PHAssetsArchive.swift
//  MiniPhotos
//
//  Created by SeoGiwon on 02/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

protocol PHAssetsIndexable {
    var phAssets: [PHAsset] { get set }
}

protocol PHAssetsSearchable {
    func nearestIndex(for phAsset: PHAsset) -> Int?
}
