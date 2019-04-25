//
//  DisappearingTransitionLayout.swift
//  MiniPhotos
//
//  Created by SeoGiwon on 22/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class DisappearingTransitionLayout: StickyHeadersCollectionViewFlowLayout {

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        
        let a = updateItems
        
        super.prepare(forCollectionViewUpdates: updateItems)
        
        
    }
    
    override func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        
        let layout = oldLayout
        
        
    }
    
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attr =
            super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)?.copy()
                as? UICollectionViewLayoutAttributes
//        attr?.center = CGPoint(x: 300, y: 300)
        
        
        return attr;
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        
        if let attr = super.layoutAttributesForItem(at: indexPath) {
            
            attr.center = CGPoint(x: attr.center.x + 50, y: attr.center.y)
            
            
            
            return attr
        }
        
        
        
        return nil
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attr =
            super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)?.copy()
                as? UICollectionViewLayoutAttributes
        
        
//        attr?.center = CGPoint(x: 300, y: 300)
        
        return attr;
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attr = super.layoutAttributesForElements(in: rect) {
            let newAttr = attr.compactMap{self.layoutAttributesForItem(at: $0.indexPath)}
            return newAttr
        } else {
            return nil
        }        
    }
}
