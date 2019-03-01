//
//  VectorCalculator.swift
//  TestsOnGiwonVector
//
//  Created by SeoGiwon on 28/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class VectorCalculator {

    private var boundaryRect = CGRect.zero
    
    init(boundaryRect: CGRect) {
        self.boundaryRect = boundaryRect
    }
    
    func vectorForReachingBoundary(lengthOfOneStep: CGFloat, pointer: CGPoint, from point: CGPoint) -> GiwonVector {
        
        var vector = GiwonVector()
        vector.pointer = pointer
        vector.magnitude = lengthOfOneStep
        
        var workingPoint = point
        var totalLength: CGFloat = 0
        
        while(true) {
            
            if self.boundaryRect.contains(workingPoint) == false {
                break
            }
            
            workingPoint = workingPoint.move(vector: vector)
            totalLength = totalLength + lengthOfOneStep
        }
        
        vector.magnitude = totalLength
        
        return vector
    }
    
}
