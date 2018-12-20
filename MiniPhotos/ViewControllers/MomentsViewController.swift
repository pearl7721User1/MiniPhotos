//
//  MomentsViewController.swift
//  PhotokitMomentsTesting
//
//  Created by SeoGiwon on 12/28/16.
//  Copyright © 2016 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class MomentsViewController: UIViewController, UICollectionViewDataSource, WhichIndexPathToShow {
    
    var viewLoadTimeIndexPath: IndexPath?

    var dataSource: [MomentsDataSourceElement]?
    
    // collection view for displaying the asset thumbnails
    @IBOutlet weak var collectionView: MomentsCommonCollectionView!
    
    private var viewDidLayoutSubviewsForTheFirstTime = true
    
    // MARK: - View Cycle
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        (UIApplication.shared.delegate as! AppDelegate).askPhotosAccessPerission()
        
        
        collectionView.collectionViewType = .Moments
        
        // create data source
        self.populatePhotosIfDataSourceIsAvailable()
        
        NotificationCenter.default.addObserver(self, selector: #selector(populatePhotosIfDataSourceIsAvailable), name: Notification.Name("PHAssetsLoaded"), object: nil)

        var leftBarButtonItem: UIBarButtonItem {
            let backArrowImage = UIImage(named: "backArrow")
            let leftButton : UIButton = UIButton(type: UIButtonType.system)
            leftButton.setImage(backArrowImage, for: .normal)
            leftButton.setTitle(" Back", for: .normal)
            leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            leftButton.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
            
            return UIBarButtonItem(customView: leftButton)
        }
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backAction(sender: UIBarButtonItem) {
        // custom actions here
        (self.navigationController as! MomentsClusterNavigationController).zoomOut(from: self, to: nil)
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    override func viewDidLayoutSubviews() {
        
        if let dataSource = dataSource {
            if (viewDidLayoutSubviewsForTheFirstTime) {
                viewDidLayoutSubviewsForTheFirstTime = false
                
                let lastIndexPath = IndexPath(item: dataSource.last!.phAssets.count-1, section: dataSource.count-1)
                
                collectionView.scrollToItem(at: lastIndexPath, at: [.left, .bottom], animated: false)
            }
        }
        
        
        
    }
    
    
    
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridViewCell.self), for: indexPath) as? GridViewCell else { fatalError("failed to dequeue GridViewCell") }
        
        
        if let dataSource = dataSource {
            let phAsset = dataSource[indexPath.section].phAssets[indexPath.row]
            
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
        
        if let dataSource = dataSource {
            return dataSource[section].phAssets.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let dataSource = dataSource {
            return dataSource.count
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

extension MomentsViewController {
    @objc fileprivate func populatePhotosIfDataSourceIsAvailable() {
        self.dataSource = (self.navigationController as! MomentsClusterNavigationController).dataSourceProvider?.momentsDataSource()
        
        DispatchQueue.main.async {
            if self.dataSource != nil {
                self.collectionView.reloadData()
                self.collectionView.noAnyContentsAvailableView.isHidden = true
            }
        }
        
        
        
    }
}
