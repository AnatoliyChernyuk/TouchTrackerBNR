//
//  Line.swift
//  TouchTrackerBNR
//
//  Created by Anatoliy Chernyuk on 1/10/18.
//  Copyright © 2018 Anatoliy Chernyuk. All rights reserved.
//

import Foundation
import CoreGraphics

struct Line {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    
    var angleSin: CGFloat { // Returns sine of the angle as a CGfloat accepted by UIColor initializer
        let x = Double(abs(Int32(end.x - begin.x)))
        let y = Double(abs(Int32(end.y - begin.y)))
        let h = sqrt(pow(x, 2) + pow(y, 2))
        return CGFloat(y / h)
    }
}
