//
//  DrawView.swift
//  TouchTrackerBNR
//
//  Created by Anatoliy Chernyuk on 1/10/18.
//  Copyright © 2018 Anatoliy Chernyuk. All rights reserved.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var moveRecognizer: UIPanGestureRecognizer!
    
    //Solution to Golden Challenge
    var circleTouches = [NSValue: CGPoint]()
    var currentCircle: Circle?
    var finishedCircles = [Circle]()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveLine(_:)))
        moveRecognizer.cancelsTouchesInView = false
        moveRecognizer.delegate = self
        addGestureRecognizer(moveRecognizer)
    }
    
    private func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    //Solution to Golden Challenge
    private func strokeCircle(_ circle: Circle) {
        let path = UIBezierPath(ovalIn: circle.circleRectangle)
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
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine)
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
            completeCircle()
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
        if touches.count == 2, let _ = currentCircle {
            updateCirle(fromTouches: touches)
            finishedCircles.append(currentCircle!)
            currentCircle = nil
            circleTouches.removeAll()
        } else {
            completeCircle()
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - Circle helper methods
    private func updateCirle(fromTouches touches: Set<UITouch>) {
        for touch in touches {
            let location = touch.location(in: self)
            let key = NSValue(nonretainedObject: touch)
            circleTouches[key] = location
        }
        let locations = Array(circleTouches.values)
        currentCircle!.setLocation(locations)
    }
    
    private func completeCircle() {
        if let circle = currentCircle {
            finishedCircles.append(circle)
            currentCircle = nil
            circleTouches.removeAll()
        }
    }
    
    //MARK: - Gesture recognizers helper methods
    @objc private func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        selectedLineIndex = nil
        currentLines.removeAll()
        finishedLines.removeAll()
        finishedCircles.removeAll()
        circleTouches.removeAll()
        currentCircle = nil
        setNeedsDisplay()
    }
    
    @objc private func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a single tap")
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        let menu = UIMenuController.shared
        if let _ = selectedLineIndex {
            becomeFirstResponder() //Make the DrawView the target of menu item action messages
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(deleteLine(_:)))
            menu.menuItems = [deleteItem]
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            menu.setMenuVisible(false, animated: true)
        }
        
        
        setNeedsDisplay()
    }
    
    private func indexOfLine(at point: CGPoint) -> Int? {
        //Find a line close to point
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            //Check few point on a line
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                //If the tapped point is within 20 points, let's  return this line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        //If nothing is close enough to the tapped point, then we did not select a line
        return nil
    }
    
    @objc private func deleteLine(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            setNeedsDisplay()
        }
    }
    
    @objc private func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
        } else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    }
    
    @objc private func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        if let index = selectedLineIndex {
            if gestureRecognizer.state == .changed {
                let translations = gestureRecognizer.translation(in: self) // Tracks how far pan moved from its initial position
                finishedLines[index].begin.x += translations.x
                finishedLines[index].begin.y += translations.y
                finishedLines[index].end.x += translations.x
                finishedLines[index].end.y += translations.y
                gestureRecognizer.setTranslation(CGPoint.zero, in: self) // Reloads gesture's initial point
                setNeedsDisplay()
            } else {
                return
            }
        }
    }
}












































