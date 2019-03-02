//
//  The.swift
//  MiniPhotos
//
//  Created by SeoGiwon on 01/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

struct IndexPathTransitionInfo {
    
    var indexPaths = [IndexPath]()
    var vectors = [GiwonVector]()
    var scale = CGSize(width: 1, height: 1)
    
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
    
    mutating func add(indexPathTransitionInfo:IndexPathTransitionInfo) {
        self.indexPaths.append(contentsOf: indexPathTransitionInfo.indexPaths)
        self.vectors.append(contentsOf: indexPathTransitionInfo.vectors)
    }
}
