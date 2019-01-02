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
    
    var dataSource: [PHCollectionListHolder]?
    var filteredDataSource: [StringHolder]?
    
    var phAssetsToShowAtViewLoad: PHAsset?
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    // collection view for displaying the asset thumbnails
    @IBOutlet weak var collectionView: MomentsCommonCollectionView!
    
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewType = .MomentsCluster
        
        
        // create data source
        self.populatePhotosIfDataSourceIsAvailable()
        
        // create display index map
        NotificationCenter.default.addObserver(self, selector: #selector(populatePhotosIfDataSourceIsAvailable), name: Notification.Name("PHAssetsLoaded"), object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let phAssetsToShowAtViewLoad = self.phAssetsToShowAtViewLoad {
            
            for (i,v) in self.filteredDataSource!.enumerated() {
                if let index = v.nearestIndex(for: phAssetsToShowAtViewLoad) {
                    
                    let theIndexPath = IndexPath(item: index, section: i)
                    collectionView.scrollToItem(at: theIndexPath, at: [.left, .top], animated: false)
                    break
                }
            }
        }
        
    }
    
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridViewCell.self), for: indexPath) as? GridViewCell else { fatalError("failed to dequeue GridViewCell") }
        
        if let filteredDataSource = filteredDataSource {
            let phAsset = filteredDataSource[indexPath.section].phAssets[indexPath.row]
            
            if let image = imageCache.object(forKey: phAsset.localIdentifier as NSString) {
                cell.thumbnailImage = image
                print("cached")
            } else {
                
                print("NOT")
                cell.representedAssetIdentifier = phAsset.localIdentifier
                PHImageManager().requestImage(for: phAsset, targetSize: self.collectionView.thumbnailSize(), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                    
                    // The cell may have been recycled by the time this handler gets called;
                    // set the cell's thumbnail image only if it's still showing the same asset.
                    if cell.representedAssetIdentifier == phAsset.localIdentifier {
                        cell.thumbnailImage = image
                    }
                })
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let filteredDataSource = filteredDataSource {
            return filteredDataSource[section].phAssets.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let filteredDataSource = filteredDataSource {
            return filteredDataSource.count
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
            
            if let filteredDataSource = filteredDataSource {
                label.text = filteredDataSource[indexPath.section].string
            }
            
            return headerView
            
        default:
            
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let filteredDataSource = filteredDataSource {
            
            let phAsset = filteredDataSource[indexPath.section].phAssets[indexPath.row]
            (self.navigationController as! PhotosNavigationController).zoomIn(to: phAsset)
            
        }
    }
    
}

extension MomentsClusterViewController {
    @objc fileprivate func populatePhotosIfDataSourceIsAvailable() {
        // what this function does:
        // 1 load dataSource and filteredDataSource property
        // 2 set image cache
        // 3 reload collection view
        
        self.dataSource = (self.navigationController as! PhotosNavigationController).dataSourceProvider?.momentsClusterDataSource()
        
        guard let dataSource = self.dataSource,
            let collectionView = self.collectionView else {
            return
        }
        
        self.filteredDataSource = filteredToStringHolders(from: dataSource)
        
        
        // iterate data source and set image cache
        let imageCache = self.imageCache
        
        // create request options for all thumbnail images to cache them
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .opportunistic
        requestOptions.resizeMode = .fast
        requestOptions.isSynchronous = true
        
        for dataSourceElement in dataSource {
            for phasset in dataSourceElement.phAssets {
                
                PHImageManager().requestImage(for: phasset, targetSize: collectionView.thumbnailSize(), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, _ in
                    
                    if let image = image {
                        imageCache.setObject(image, forKey: phasset.localIdentifier as NSString)
                    }
                })
            }
        }
        
        collectionView.noAnyContentsAvailableView.isHidden = true
        collectionView.reloadData()
    }
    
    private func filteredToStringHolders(from srcDataSource: [PHCollectionListHolder]) -> [StringHolder] {
        
        var stringHolderArray = [StringHolder]()

        for (_,v) in srcDataSource.enumerated() {
            
            stringHolderArray.append(v.filteredToStringHolder())
        }
        
        return stringHolderArray
    }

}
