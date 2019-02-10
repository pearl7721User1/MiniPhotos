//
//  MyViewController.swift
//  MiniPhotos
//
//  Created by SeoGiwon on 10/12/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class PhotoLibraryPermissionCheckViewController: UIViewController {

    var noAnyContentsAvailableView = ViewForPermissionUnavailable()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if PHPhotoLibrary.authorizationStatus() != .notDetermined {
            showPhotoLibaryAccessUnavailableView()
        }
    }
    
    @IBAction func allowAccessButtonTapped(_ sender: UIButton) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                
                // send notification
                NotificationCenter.default.post(name: Notification.Name("PHAssetsLoaded"), object: nil)
            } else {
                self.showPhotoLibaryAccessUnavailableView()
                
            }
        }
        
    }
    
    private func showPhotoLibaryAccessUnavailableView() {
        
        if self.noAnyContentsAvailableView.superview == nil {
            self.view.addSubview(noAnyContentsAvailableView)
        }
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.noAnyContentsAvailableView.frame = self.view.bounds
    }
}
