//
//  MomentsViewController.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 12/28/16.
//  Copyright © 2016 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class MomentsViewController: UIViewController, UICollectionViewDataSource {

    private var dataSource: [MomentsDataSourceElement]!
    private var imageCache = NSCache<NSString, UIImage>()
    
    // collection view for displaying the asset thumbnails
    @IBOutlet weak var collectionView: MomentsCommonCollectionView!
    
    // MARK: - View Cycle
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.showNotPermittedView(show: false)
        collectionView.collectionViewType = .Moments
        
        // fetch all moments
        (self.navigationController as! MomentsClusterNavigationController).initDataSourceProvider()
        
        // create data source
        dataSource = (self.navigationController as! MomentsClusterNavigationController).dataSourceProvider.momentsDataSource()
        
        // create image cache
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .opportunistic
        requestOptions.resizeMode = .fast
        requestOptions.isSynchronous = true
        
        // iterate data source
        for dataSourceElement in dataSource! {
            for phasset in dataSourceElement.phAssets {
                
                PHImageManager().requestImage(for: phasset, targetSize: self.collectionView.thumbnailSize(), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, _ in
                    
                    if let image = image {
                        self.imageCache.setObject(image, forKey: phasset.localIdentifier as NSString)
                    }
                })
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    override func viewDidLayoutSubviews() {
        
        
        
    }
    
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridViewCell.self), for: indexPath) as? GridViewCell else { fatalError("failed to dequeue GridViewCell") }
        
        
        if let dataSource = dataSource {
            let phAsset = dataSource[indexPath.section].phAssets[indexPath.row]
            
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
        
        return dataSource[section].phAssets.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // load collection header view that reads time, date for each collection
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ViewHeader",
                                                                             for: indexPath)
            let label = headerView.viewWithTag(10) as! UILabel
            
            if let dataSource = dataSource,
                let startDate = dataSource[indexPath.section].phAssetCollection.startDate,
                let endDate = dataSource[indexPath.section].phAssetCollection.endDate {
                
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
    
    
}

