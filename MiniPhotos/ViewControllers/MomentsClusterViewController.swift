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
    
    var dataSource: [MomentsClusterDataSourceElement]?
    var filteredDataSource: [MomentsClusterDataSourceElement]?
    
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
            
            if let filteredDataSource = filteredDataSource,
                let startDate = filteredDataSource[indexPath.section].phCollectionList.startDate,
            let endDate = filteredDataSource[indexPath.section].phCollectionList.endDate {
                
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let filteredDataSource = filteredDataSource {
            
            let phAsset = filteredDataSource[indexPath.section].phAssets[indexPath.row]
            (self.navigationController as! MomentsClusterNavigationController).zoomIn(from: self, to: phAsset)
            
        }
    }
}

extension MomentsClusterViewController {
    @objc fileprivate func populatePhotosIfDataSourceIsAvailable() {
        
        self.dataSource = (self.navigationController as! MomentsClusterNavigationController).dataSourceProvider?.momentsClusterDataSource()
        
        if self.dataSource != nil {
            
            self.filteredDataSource = self.filteredDataSource(from: self.dataSource!)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            self.collectionView.noAnyContentsAvailableView.isHidden = true
            
            // request all thumbnail images to cache them
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .opportunistic
            requestOptions.resizeMode = .fast
            requestOptions.isSynchronous = true
            
            // iterate data source
            for dataSourceElement in self.dataSource! {
                for phasset in dataSourceElement.phAssets {
                    
                    PHImageManager().requestImage(for: phasset, targetSize: self.collectionView.thumbnailSize(), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, _ in
                        
                        if let image = image {
                            self.imageCache.setObject(image, forKey: phasset.localIdentifier as NSString)
                        }
                    })
                }
            }
        }
    }
    
    private func filteredDataSource(from srcDataSource: [MomentsClusterDataSourceElement]) -> [MomentsClusterDataSourceElement] {
        
        var dstDataSource = [MomentsClusterDataSourceElement]()
        if let dataSource = dataSource {
            for (_,v) in dataSource.enumerated() {
                
                let element = MomentsClusterDataSourceElement.filteredMomentsClusterDataSourceElement(element: v)
                
                dstDataSource.append(element)
            }
        }
        
        return dstDataSource
    }
}
