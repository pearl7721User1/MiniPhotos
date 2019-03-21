//
//  MomentsViewController.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 12/28/16.
//  Copyright © 2016 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class MomentsViewController: UIViewController, UICollectionViewDataSource, IndexPathNavigation {

    var phAssetGroups: [MomentsPHAssetGroup]!
    
    // collection view for displaying the asset thumbnails
    @IBOutlet weak var collectionView: MomentsCommonCollectionView!
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewType = .Moments
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*
        if self.isMovingToParentViewController {
            // Your code...
            print("movingTo")
        }
        */
        if self.isMovingFromParentViewController {
            
            print("movingFrom")
        }
    }
    
    @objc func backAction(sender: UIBarButtonItem) {
        // custom actions here
        
        var phAssetOfInterest: PHAsset?
        if let firstIndexCell = self.collectionView.visibleCells.first,
            let phAssetGroups = self.phAssetGroups,
            let indexPath = self.collectionView.indexPath(for: firstIndexCell) {
            
            phAssetOfInterest = phAssetGroups[indexPath.section].phAssets[indexPath.row]
            
        }
        
        (self.navigationController as! PhotosNavigationController).zoomOut(to: phAssetOfInterest)
        
    }
    
    func reloadRequiredSections() -> IndexSet {
        let visibleIndexPaths = self.collectionView.visibleIndexPaths()
        let sectionAscendingIndexPaths = visibleIndexPaths.sorted { (lv, rv) -> Bool in
            return lv.section <= rv.section ? true : false
        }
        
        let lowestSection = sectionAscendingIndexPaths.first!.section
        let highestSection = sectionAscendingIndexPaths.last!.section
        
        return IndexSet(integersIn: lowestSection...highestSection)
        
    }

    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridViewCell.self), for: indexPath) as? GridViewCell else { fatalError("failed to dequeue GridViewCell") }
        
        
        if let phAssetGroups = phAssetGroups {
            let phAsset = phAssetGroups[indexPath.section].phAssets[indexPath.row]
            
            cell.representedAssetIdentifier = phAsset.localIdentifier
            PHImageManager().requestImage(for: phAsset, targetSize: self.collectionView.thumbnailSize(), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                
                // The cell may have been recycled by the time this handler gets called;
                // set the cell's thumbnail image only if it's still showing the same asset.
                if cell.representedAssetIdentifier == phAsset.localIdentifier {
                    cell.thumbnailImage = image
                }
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let phAssetGroups = phAssetGroups {
            return phAssetGroups[section].phAssets.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let phAssetGroups = phAssetGroups {
            return phAssetGroups.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // load collection header view that reads time, date for each collection
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ViewHeader",
                                                                             for: indexPath)
            let label = headerView.viewWithTag(10) as! UILabel
            
            if let phAssetGroups = phAssetGroups,
                let startDate = phAssetGroups[indexPath.section].phAssetCollection.startDate,
                let endDate = phAssetGroups[indexPath.section].phAssetCollection.endDate {
                
                let f = DateFormatter()
                f.dateStyle = .medium
                f.timeStyle = .medium
                
                label.text = "\(f.string(from: startDate)) - \(f.string(from:endDate))"
                
            }
            
            return headerView
            
        default:
            
            fatalError("Unexpected element kind")
        }
    }
    
    // MARK: - IndexPathNavigation
    func navigate(to indexPath:IndexPath, originFromVisibleContent:CGPoint) {
        
        collectionView.scrollToItem(at: indexPath, at: [.left, .top], animated: false)
        let newContentOffset = CGPoint(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y - originFromVisibleContent.y)
        collectionView.setContentOffset(newContentOffset, animated: false)
        
    }
    
    func visiblePHAssets() -> [PHAsset] {
        
        guard let phAssetGroups = phAssetGroups else {
            return [PHAsset]()
        }
        
//        let visibleIndexPaths = self.collectionView.visibleCells.map{self.collectionView.indexPath(for: $0)}.filter{$0 != nil}
        
        let visibleIndexPaths = self.collectionView.visibleIndexPaths()
        
        
        return visibleIndexPaths.map{phAssetGroups[$0.section].phAssets[$0.row]}
        
    }
    
    func rectsFromVisibleContent(indexPaths:[IndexPath?]) -> [CGRect?] {
        
        let rects = indexPaths.map { (indexPath) -> CGRect? in
            
            if let indexPath = indexPath {
                let origin = self.collectionView.originFromVisibleContent(indexPath: indexPath)
                let size = (self.collectionView.collectionViewLayout as! StickyHeadersCollectionViewFlowLayout).itemSize
                
                return CGRect(origin: origin, size: size)
            } else {
                return nil
            }
        }
        
        return rects
    }
    
    func indexPath(containing phAsset:PHAsset) -> IndexPath? {
        
        for (i,v) in phAssetGroups.enumerated() {
            for (j,u) in v.phAssets.enumerated() {
                if u.isEqual(phAsset) {
                    return IndexPath(item: j, section: i)
                }
            }
        }
        
        return nil
    }
    
    func setAppearingTransitionInfos(infos: [IndexPathTransitionInfo]) {
        (self.collectionView.collectionViewLayout as! StickyHeadersCollectionViewFlowLayout).appearingTransitionInfos = infos
    }
}
