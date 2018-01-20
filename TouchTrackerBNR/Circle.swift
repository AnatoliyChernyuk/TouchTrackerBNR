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
    
    var ovalRectangle: CGRect {                 // Cicle is boring, oval is more facinating
        let x = CGFloat(Int32(end.x - begin.x))
        let y = CGFloat(Int32(end.y - begin.y))
        let size = CGSize(width: x, height: y)
        return CGRect(origin: begin, size: size)
    }
    
    var circleRectangle: CGRect {
        let x = CGFloat(abs(Int32(end.x - begin.x)))
        let y = CGFloat(abs(Int32(end.y - begin.y)))
        let side = min(x, y)
        let size = CGSize(width: side, height: side)
        let center = CGPoint(x: (begin.x + end.x) / 2, y: (begin.y + end.y) / 2)
        let origin = CGPoint(x: center.x - side / 2, y: center.y - side / 2)
        return CGRect(origin: origin, size: size)
    }
    
    //Using this assignment function prevents losing built-in memberwise initialiser plus adds defencing
    mutating func setLocation(_ locations: [CGPoint]) {
        if locations.count != 2 {
            return
        }
        begin = locations[0]
        end = locations[1]
    }
}
