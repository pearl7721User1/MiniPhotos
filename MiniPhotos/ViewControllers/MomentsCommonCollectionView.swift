//
//  MomentsCommonCollectionView.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 31/01/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit

class MomentsCommonCollectionView: UICollectionView {

    var noAnyContentsAvailableView = ViewForPermissionUnavailable()
    
    enum CollectionViewType: Int {
        case MomentsCluster, Moments
    }
    
    var collectionViewType = CollectionViewType.MomentsCluster {
        didSet {
            let flowLayout = MomentsCommonCollectionView.flowLayout(of: collectionViewType)
            self.collectionViewLayout = flowLayout
        }
    }

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let flowLayout = MomentsCommonCollectionView.flowLayout(of: collectionViewType)
        self.collectionViewLayout = flowLayout
        
        // add unavailability view
        self.addSubview(noAnyContentsAvailableView)
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        noAnyContentsAvailableView.frame = self.bounds
    }
    
    func indexPaths(from rect:CGRect) -> [IndexPath] {
        
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
        
    }
    
    func thumbnailSize() -> CGSize {
        
        let scale = UIScreen.main.scale
        let cellSize = MomentsCommonCollectionView.cellSize(of: collectionViewType)
        let thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        return thumbnailSize
    }
    
    static private func cellSize(of collectionViewType:CollectionViewType) -> CGSize {
        
        let screenSize = UIScreen.main.bounds.size
        let spacing = MomentsCommonCollectionView.spacing(of: collectionViewType)
        
        var cellWidth: CGFloat = 0.0
        switch collectionViewType {
        case .MomentsCluster:
            cellWidth = screenSize.width / 10
        case .Moments:
            cellWidth = (screenSize.width - (spacing*3)) / 4
        }
        
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
    
    static func flowLayout(of collectionViewType:CollectionViewType) -> StickyHeadersCollectionViewFlowLayout {
        
        let flowLayout = StickyHeadersCollectionViewFlowLayout()
        flowLayout.itemSize = MomentsCommonCollectionView.cellSize(of: collectionViewType)
        flowLayout.minimumLineSpacing = self.spacing(of: collectionViewType)
        flowLayout.minimumInteritemSpacing = MomentsCommonCollectionView.spacing(of: collectionViewType)
        flowLayout.headerReferenceSize = CGSize(width: 50, height: 50)
        return flowLayout
    }
    
    static func spacing(of collectionViewType:CollectionViewType) -> CGFloat {
        
        switch collectionViewType {
        case .MomentsCluster: return 0
        case .Moments: return 1.5
        }
    }
    
    
}


