//
//  DisappearingTransitionLayout.swift
//  MiniPhotos
//
//  Created by SeoGiwon on 22/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class DisappearingTransitionLayout: StickyHeadersCollectionViewFlowLayout {

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.layoutAttributesForItem(at: indexPath)
        
        attr?.center = CGPoint.init(x: -200, y: -200)
        
        return attr
    }
}
