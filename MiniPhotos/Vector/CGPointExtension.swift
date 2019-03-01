//
//  CGRectExtension.swift
//  TestsOnGiwonVector
//
//  Created by SeoGiwon on 28/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

extension CGPoint {
 
    func move(vector: GiwonVector) -> CGPoint {
        
        let angle = atan2(vector.pointer.y, vector.pointer.x)
        
        let xOffset = vector.magnitude * cos(angle)
        let yOffset = vector.magnitude * sin(angle)
        
        let newPoint = CGPoint(x: self.x + xOffset, y: self.y + yOffset)        
        return newPoint
    }
}
