//
//  The.swift
//  MiniPhotos
//
//  Created by SeoGiwon on 01/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

struct IndexPathTransitionInfo {
    
    private var indexPaths = [IndexPath]()
    private var vectors = [GiwonVector]()
    
    mutating func add(indexPath:IndexPath, vector:GiwonVector) {
        self.indexPaths.append(indexPath)
        self.vectors.append(vector)
    }
    
    func vector(for indexPath:IndexPath) -> GiwonVector? {
        
        for (i,v) in indexPaths.enumerated() {
            if v == indexPath {
                return vectors[i]
            }
            
        }
        
        return nil
    }
}
