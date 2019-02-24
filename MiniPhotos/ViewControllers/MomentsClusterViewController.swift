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
        let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
        let sectionAscendingIndexPaths = visibleIndexPaths.sorted { (lv, rv) -> Bool in
            return lv.section <= rv.section ? true : false
        }
        
        let lowestSection = sectionAscendingIndexPaths.first!.section
        let highestSection = sectionAscendingIndexPaths.last!.section
        
        return IndexSet(integersIn: lowestSection...highestSection)
        
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
            
            self.collectionView.reloadSections(IndexSet(integersIn: lowestSection...highestSection))
//            self.collectionView.collectionViewLayout.invalidateLayout()
            
        }, completion: nil)
    }
    
    
    @IBAction func barButton1Tapped(_ sender: UIBarButtonItem) {
        
        
        
        
        
        
        let indexOfInterest = IndexPath(item: 0, section: 5)
        /*
        //
        let attributes = momentsClusterLayout.layoutAttributesForSupplementaryView(ofKind:UICollectionElementKindSectionHeader, at: indexOfInterest)
        
        print("o:\(attributes!.frame.origin.x) \(attributes!.frame.origin.y) \(attributes!.frame.size.width) \(attributes!.frame.size.height)")
 */
        
        let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
        
        let sectionAscendingIndexPaths = visibleIndexPaths.sorted { (lv, rv) -> Bool in
            return lv.section <= rv.section ? true : false
        }
        
        let lowestSection = sectionAscendingIndexPaths.first!.section
        let highestSection = sectionAscendingIndexPaths.last!.section
        
        
        
        
        describe(indexPath: IndexPath(item: 0, section: 5), layout: self.collectionView.collectionViewLayout)
        
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
            
//            self.collectionView.collectionViewLayout = MomentsCommonCollectionView.flowLayout(of: .Moments)
//            self.collectionView.scrollToItem(at: indexOfInterest, at: .bottom, animated: false)
            
            self.collectionView.reloadSections(IndexSet(integersIn: lowestSection...highestSection))
            /*
            self.collectionView.performBatchUpdates({
                
                self.collectionView.scrollToItem(at: indexOfInterest, at: .bottom, animated: false)
                self.collectionView.reloadSections(IndexSet(integersIn: 0...20))
            }, completion: nil)
            */
//            self.collectionView.scrollToItem(at: indexOfInterest, at: .bottom, animated: false)
            
        }, completion: { finished in
            
            let momentsClusterLayout = self.collectionView.collectionViewLayout
            
            self.describe(indexPath: IndexPath(item: 0, section: 5), layout: momentsClusterLayout)
            
        })
 
        
        
        
    }
    
    @IBAction func barButton2Tapped(_ sender: UIBarButtonItem) {
   
//        self.describe(indexPath: IndexPath(item: 0, section: 0), layout: self.collectionView.collectionViewLayout)
        
    self.collectionView.setCollectionViewLayout(MomentsCommonCollectionView.flowLayout(of: .MomentsCluster), animated: false)
        
        
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
        (self.navigationController as! PhotosNavigationController).zoomIn(to: phAsset, from: indexPath)
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
