//
//  MyViewController.swift
//  MiniPhotos
//
//  Created by SeoGiwon on 10/12/2018.
//  Copyright © 2018 SeoGiwon. All rights reserved.
//

import UIKit
import Photos

class MyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // PHFetchOptions of creationDate ascending
        let creationDateFetchOption: PHFetchOptions = {
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
            return options
        }()
        
        // fetch all moments PHAssets
        let assetFetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: creationDateFetchOption)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
