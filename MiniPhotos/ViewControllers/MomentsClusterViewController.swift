//
//  MomentsClusterViewController.swift
//  TestsOnPhotosContentOffsetDecisionInCollectionView
//
//  Created by GIWON1 on 2018. 11. 29..
//  Copyright © 2018년 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class MomentsClusterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var phAssetGroups: [ClusterPHAssetGroup]!
    private var filteredPHAssetGroups: [FilteredClusterPHAssetGroup]!
    private var imageCache = NSCache<NSString, UIImage>()
    
    // collection view for displaying the asset thumbnails
    @IBOutlet weak var collectionView: MomentsCommonCollectionView!
    
    func reloadRequiredSections() -> IndexSet {
        let visibleIndexPaths = self.collectionView.visibleIndexPaths()
        let sectionAscendingIndexPaths = visibleIndexPaths.sorted { (lv, rv) -> Bool in
            return lv.section <= rv.section ? true : false
        }
        
        let lowestSection = sectionAscendingIndexPaths.first!.section
        let highestSection = sectionAscendingIndexPaths.last!.section
        
        return IndexSet(integersIn: lowestSection...highestSection)
        
    }
    
    
    @IBAction func barButton1Tapped(_ sender: UIBarButtonItem) {
        
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: [.left, .top], animated: false)
        
    }
    
    @IBAction func barButton2Tapped(_ sender: UIBarButtonItem) {
   
    }
    
    private func describe(indexPath: IndexPath, layout: UICollectionViewLayout) {
        
        print("=========================")
        if let dis = layout.finalLayoutAttributesForDisappearingItem(at: indexPath) {
            print("dis, s:\(indexPath.section) i:\(indexPath.item), origin:\(dis.frame.origin.x), \(dis.frame.origin.y) size:\(dis.frame.size.width), \(dis.frame.size.height)")
        }
        if let inis = layout.initialLayoutAttributesForAppearingItem(at: indexPath) {
            print("inis, s:\(indexPath.section) i:\(indexPath.item), origin:\(inis.frame.origin.x), \(inis.frame.origin.y) size:\(inis.frame.size.width), \(inis.frame.size.height)")
        }
        if let cur = layout.layoutAttributesForItem(at: indexPath) {
            print("cur, s:\(indexPath.section) i:\(indexPath.item), origin:\(cur.frame.origin.x), \(cur.frame.origin.y) size:\(cur.frame.size.width), \(cur.frame.size.height)")
        }
 
        
        print("==========================")
        
        
    }
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewType = .MomentsCluster
        
        self.filteredPHAssetGroups = filteredGroup(from: phAssetGroups)
        saveImages(from: self.filteredPHAssetGroups, to: self.imageCache)
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if let phAssetsToShowAtViewLoad = self.phAssetsToShowAtViewLoad {
            
            for (i,v) in self.filteredPHAssetGroups!.enumerated() {
                if let index = v.nearestIndex(for: phAssetsToShowAtViewLoad) {
                    
                    let theIndexPath = IndexPath(item: index, section: i)
                    collectionView.scrollToItem(at: theIndexPath, at: [.left, .top], animated: false)
                    break
                }
            }
        }
        */
    }
    
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridViewCell.self), for: indexPath) as? GridViewCell else { fatalError("failed to dequeue GridViewCell") }
        
        let phAsset = filteredPHAssetGroups[indexPath.section].phAssets[indexPath.row]
        
        if let image = imageCache.object(forKey: phAsset.localIdentifier as NSString) {
            cell.thumbnailImage = image
//            print("cached")
        } else {
            
//            print("NOT")
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
        
        return filteredPHAssetGroups[section].phAssets.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return filteredPHAssetGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // load collection header view that reads time, date for each collection
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ViewHeader",
                                                                             for: indexPath)
            let label = headerView.viewWithTag(10) as! UILabel
            label.text = filteredPHAssetGroups[indexPath.section].string

            return headerView
            
        default:
            
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let phAsset = filteredPHAssetGroups[indexPath.section].phAssets[indexPath.row]
        let originFromVisibleContent = self.collectionView.originFromVisibleContent(indexPath: indexPath)
        
        (self.navigationController as! PhotosNavigationController).zoomIn(to: phAsset, originFromVisibleContent: originFromVisibleContent)
        
    }
    
    func visibleIndexPaths(excluding phAssets: [PHAsset]) -> [IndexPath] {
        
        let visibleIndexPaths = self.collectionView.visibleCells.map{self.collectionView.indexPath(for:
            $0)}.filter{$0 != nil}
        
        var excludingIndexPaths = [IndexPath]()
        for (i,v) in phAssets.enumerated() {
            if let theIndexPath = indexPath(containing: v) {
                excludingIndexPaths.append(theIndexPath)
            }
        }
        
        let ExclusionCompletedIndexPaths = visibleIndexPaths.filter { (indexPath: IndexPath?) -> Bool in
            
            let indexPath = indexPath!
            
            for (i,v) in excludingIndexPaths.enumerated() {
                if v == indexPath {
                    return false
                }
            }
            
            return true
        }
        
        var theIndexPaths = [IndexPath]()
        for (i,v) in ExclusionCompletedIndexPaths.enumerated() {
            
            if let indexPath = v {
                theIndexPaths.append(indexPath)
            }
            
        }
        
        return theIndexPaths
    }
    
    func indexPath(containing phAsset:PHAsset) -> IndexPath? {
        
        for (i,v) in filteredPHAssetGroups.enumerated() {
            for (j,u) in v.phAssets.enumerated() {
                if u.isEqual(phAsset) {
                    return IndexPath(item: j, section: i)
                }
            }
        }
        
        return nil
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
    
    func setDisappearingTransitionInfo(info: IndexPathTransitionInfo) {
        (self.collectionView.collectionViewLayout as! StickyHeadersCollectionViewFlowLayout).disappearingTransitionInfo = info
    }
    
    private func saveImages(from phAssetGroups:[FilteredClusterPHAssetGroup], to cache:NSCache<NSString, UIImage>) {
        
        // create request options for all thumbnail images to cache them
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .opportunistic
        requestOptions.resizeMode = .fast
        requestOptions.isSynchronous = true
        
        for phAssetGroup in phAssetGroups {
            for phasset in phAssetGroup.phAssets {
                
                PHImageManager().requestImage(for: phasset, targetSize: collectionView.thumbnailSize(), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, _ in
                    
                    if let image = image {
                        cache.setObject(image, forKey: phasset.localIdentifier as NSString)
                    }
                })
            }
        }
    }
}

extension MomentsClusterViewController {
    
    
    private func filteredGroup(from phAssetGroups: [ClusterPHAssetGroup]) -> [FilteredClusterPHAssetGroup] {
        
        var filteredPHAssetGroups = [FilteredClusterPHAssetGroup]()

        for (_,v) in phAssetGroups.enumerated() {
            
            filteredPHAssetGroups.append(v.filteredClusterPHAssetGroup())
        }
        
        return filteredPHAssetGroups
    }

}
