//
//  Circle.swift
//  TouchTrackerBNR
//
//  Created by Anatoliy Chernyuk on 1/15/18.
//  Copyright © 2018 Anatoliy Chernyuk. All rights reserved.
//

import Foundation
import CoreGraphics

struct Circle {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    
    var rectangle: CGRect {
        let x = CGFloat((Int32(end.x - begin.x)))
        let y = CGFloat((Int32(end.y - begin.y)))
        let size = CGSize(width: x, height: y)
        return CGRect(origin: begin, size: size)
    }
    
    mutating func setLocation(_ locations: [CGPoint]) {
        if locations.count != 2 {
            return
        }
        begin = locations[0]
        end = locations[1]
    }
}
