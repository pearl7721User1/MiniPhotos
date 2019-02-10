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
        (self.navigationController as! PhotosNavigationController).zoomIn(to: phAsset)
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
