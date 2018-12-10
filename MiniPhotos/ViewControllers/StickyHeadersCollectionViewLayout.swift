//
//  StickyHeadersCollectionViewFlowLayout.swift
//  StickyHeaders
//
//  Created by Bart Jacobs on 01/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit


class StickyHeadersCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var topOffset: CGFloat = 64
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // Helpers
        let sectionsToAdd = NSMutableIndexSet()
        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for layoutAttributesSet in layoutAttributes {
            if layoutAttributesSet.representedElementCategory == .cell {
                // Add Layout Attributes
                newLayoutAttributes.append(layoutAttributesSet)
                
                // Update Sections to Add
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
                
            } else if layoutAttributesSet.representedElementCategory == .supplementaryView {
                // Update Sections to Add
                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
            }
        }
        
        for section in sectionsToAdd {
            let indexPath = IndexPath(item: 0, section: section)
            
            if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
                newLayoutAttributes.append(sectionAttributes)
            }
            
        }
        
        return newLayoutAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        guard let boundaries = boundaries(forSection: indexPath.section) else { return layoutAttributes }
        guard let collectionView = collectionView else { return layoutAttributes }
        
        
        // Helpers
        let contentOffsetY = collectionView.contentOffset.y
        var frameForSupplementaryView = layoutAttributes.frame
        
        let minimum = boundaries.minimum - frameForSupplementaryView.height
        let maximum = boundaries.maximum - frameForSupplementaryView.height
        
        //        print("*************************")
        //        print("contentOffsetY:\(contentOffsetY), minimum: \(minimum), maximum: \(maximum)")
        
        
        let newContentOffsetY = contentOffsetY + topOffset
        
        
        if newContentOffsetY < minimum {
            frameForSupplementaryView.origin.y = minimum
            //            print("min")
        } else if newContentOffsetY > maximum {
            frameForSupplementaryView.origin.y = maximum
            //            print("max")
        } else {
            frameForSupplementaryView.origin.y = newContentOffsetY
            
            //            print("normal")
            
            if elementKind == UICollectionElementKindSectionHeader {
                // print("indexPathSection:\(indexPath.section),Row:\(indexPath.row)")
            } else {
                // print("not")
            }
            
            
        }
        
        
        //print("layoutAttributesY:\(layoutAttributes.frame.origin.y), height: \(layoutAttributes.frame.size.height)")
        
        layoutAttributes.frame = frameForSupplementaryView
        
        //print("New layoutAttributesY:\(layoutAttributes.frame.origin.y), height: \(layoutAttributes.frame.size.height)")
        
        //print("*************************")
        
        return layoutAttributes
    }
    
    // MARK: - Helper Methods
    
    private func boundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat)? {
        // Helpers
        var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))
        
        // Exit Early
        guard let collectionView = collectionView else { return result }
        
        // Fetch Number of Items for Section
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        
        // Exit Early
        guard numberOfItems > 0 else { return result }
        
        if let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
            let lastItem = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: section)) {
            
            
            //            print("section: \(section), firstItem:\(firstItem.frame.origin.x) \(firstItem.frame.origin.y) \(firstItem.frame.size.width) \(firstItem.frame.size.height)")
            
            result.minimum = firstItem.frame.minY
            result.maximum = lastItem.frame.maxY
            
            // Take Header Size Into Account
            //            result.minimum -= headerReferenceSize.height
            //            result.maximum -= headerReferenceSize.height
            
            // Take Section Inset Into Account
            result.minimum -= sectionInset.top
            result.maximum += (sectionInset.top + sectionInset.bottom)
        }
        
        return result
    }
    
    
}


