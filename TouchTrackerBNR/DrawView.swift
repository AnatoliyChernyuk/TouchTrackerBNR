//
//  DrawView.swift
//  TouchTrackerBNR
//
//  Created by Anatoliy Chernyuk on 1/10/18.
//  Copyright © 2018 Anatoliy Chernyuk. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    
    //Solution to Golden Challenge
    var circleTouches = [NSValue: CGPoint]()
    var currentCircle: Circle?
    var finishedCircles = [Circle]()
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    //Solution to Golden Challenge
    func strokeCircle(_ circle: Circle) {
        let path = UIBezierPath(ovalIn: circle.rectangle)
        path.lineWidth = lineThickness
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finishedLines {
            stroke(line)
        }
        
        //Solution to the Golden Challenge
        for circle in finishedCircles {
            strokeCircle(circle)
        }
        
        currentLineColor.setStroke()
        
        //Solution to the Golden Challenge
        if let circle = currentCircle {
            strokeCircle(circle)
        }
        
        for (_, line) in currentLines {
            //Solution to the Silver Challenge
            currentLineColor = UIColor(hue: line.angleSin, saturation: 1, brightness: 1, alpha: 1)
            currentLineColor.setStroke()
            stroke(line)
        }
    }
    
    //MARK: - Handling touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        //Solution to the Golden Challenge
        if touches.count == 2 {
            currentCircle = Circle()
            updateCirle(fromTouches: touches)
        } else {
            //comleteCircle()
            for touch in touches {
                let location = touch.location(in: self)
                let newLine = Line(begin: location, end: location)
                let key = NSValue(nonretainedObject: touch)
                currentLines[key] = newLine
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        //Solution to the Golden Challenge
        if touches.count == 2, let _ = currentCircle {
                updateCirle(fromTouches: touches)
        } else {
            //comleteCircle()
            for touch in touches {
                let key = NSValue(nonretainedObject: touch)
                currentLines[key]?.end = touch.location(in: self)
                
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        //Solution to Golden Challenge
        if touches.count == 2 {
            updateCirle(fromTouches: touches)
            finishedCircles.append(currentCircle!)
            currentCircle = nil
            circleTouches.removeAll()
        } else {
            //comleteCircle()
            for touch in touches {
                let key = NSValue(nonretainedObject: touch)
                if var line = currentLines[key] {
                    line.end = touch.location(in: self)
                    finishedLines.append(line)
                    currentLines.removeValue(forKey: key)
                }
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        currentLines.removeAll()
        circleTouches.removeAll()
        currentCircle = nil
        setNeedsDisplay()
    }
    
    private func updateCirle(fromTouches touches: Set<UITouch>) {
        for touch in touches {
            let location = touch.location(in: self)
            let key = NSValue(nonretainedObject: touch)
            circleTouches[key] = location
        }
        let locations = Array(circleTouches.values)
        currentCircle!.setLocation(locations)
    }
    
    private func comleteCircle() {
        if let circle = currentCircle {
            finishedCircles.append(circle)
            currentCircle = nil
        }
        circleTouches.removeAll()
    }
    
    private func updateLines(fromTouches touches: Set<UITouch>) {
        
    }
    
}












































