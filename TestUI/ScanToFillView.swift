//
//  ViewController.swift
//  TestUI
//
//  Created by Artem on 13.04.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class ScanToFillView: UIView {
    
    var dictOfCenters = [Dots: CGPoint]() {
        didSet {
            let someDict = dictOfCenters.filter { 0 > $0.value.x || $0.value.x > bounds.maxX || 0 > $0.value.y || $0.value.y > bounds.maxY }
            if someDict.count != 0 {
                for keyValue in someDict {
                    dictOfCenters[keyValue.key]!.x = min(max(dictOfCenters[keyValue.key]!.x, 0), bounds.width)
                    dictOfCenters[keyValue.key]!.y = min(max(dictOfCenters[keyValue.key]!.y, 0), bounds.height)
                }
            }
            setNeedsDisplay()
        }
    }
    
    var sideDragerLenghtMod: CGFloat = 5 // means - width of side drager = 1/(mod + 1)
    var dictOfSidesRects = [Sides: CGRect]()
    let dictOfDotsForSides: [Sides:(Dots, Dots)] = [
        .up: (.upperLeft, .upperRight),
        .down: (.lowerLeft, .lowerRight),
        .left: (.upperLeft, .lowerLeft),
        .right: (.upperRight, .lowerRight)
    ]

    func setStartingSettings() {
        dictOfCenters[.upperLeft] = CGPoint(x: bounds.width * 0.1, y: bounds.height * 0.1)
        dictOfCenters[.upperRight] = CGPoint(x: bounds.width * 0.9, y: bounds.height * 0.1)
        dictOfCenters[.lowerLeft] = CGPoint(x: bounds.width * 0.1, y: bounds.height * 0.9)
        dictOfCenters[.lowerRight] = CGPoint(x: bounds.width * 0.9, y: bounds.height * 0.9)
    }
    
    override func draw(_ rect: CGRect) {
        if dictOfCenters.count != 4 {
            print("Dot centers are not setted!")
            return
        }
        
        drawDot(with: dictOfCenters[.upperLeft]!)
        drawDot(with: dictOfCenters[.upperRight]!)
        drawDot(with: dictOfCenters[.lowerLeft]!)
        drawDot(with: dictOfCenters[.lowerRight]!)
        let mainRectPath = getMainRectPath()
        mainRectPath.stroke()
        mainRectPath.fill()

        let upBeziarPath = getSideRect(between: .upperLeft, and: .upperRight)
        let downBeziarPath = getSideRect(between: .lowerRight, and: .lowerLeft)
        let leftBeziarPath = getSideRect(between: .lowerLeft, and: .upperLeft)
        let rightBeziarPath = getSideRect(between: .upperRight, and: .lowerRight)

        dictOfSidesRects[.up] = upBeziarPath.bounds.insetBy(dx: -10, dy: -10)
        dictOfSidesRects[.down] = downBeziarPath.bounds.insetBy(dx: -10, dy: -10)
        dictOfSidesRects[.left] = leftBeziarPath.bounds.insetBy(dx: -10, dy: -10)
        dictOfSidesRects[.right] = rightBeziarPath.bounds.insetBy(dx: -10, dy: -10)
        
        upBeziarPath.stroke()
        downBeziarPath.stroke()
        leftBeziarPath.stroke()
        rightBeziarPath.stroke()
        
        // Uncomment to show sides touch-zones
        /*for keyValue in dictOfSidesRects {
            let bp = UIBezierPath(rect: keyValue.value)
            bp.lineWidth = 3
            UIColor.red.setStroke()
            bp.stroke()
        }*/

    }
    
    // TODO: є сенс перекинути виклик в didSet/willSet змінної dictOfCenters
    func isConvex(with newDictOfCenters: [Dots: CGPoint]) -> Bool {
        return checkingFunctions.intersection(ofLineFrom: newDictOfCenters[.upperLeft]!, to: newDictOfCenters[.lowerRight]!, withLineFrom: newDictOfCenters[.upperRight]!, to: newDictOfCenters[.lowerLeft]!)
    }
    
    private func drawDot(with center: CGPoint) {
        let path = UIBezierPath()
        path.addDot(withCenter: center)
        UIColor.azure.setFill()
        path.fill()
    }
    
    func getMainRectPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: dictOfCenters[.upperLeft]!)
        path.addLine(to: dictOfCenters[.upperRight]!)
        path.addLine(to: dictOfCenters[.lowerRight]!)
        path.addLine(to: dictOfCenters[.lowerLeft]!)
        path.close()
        path.lineWidth = 5.0
        UIColor.azure.setStroke()
        UIColor.azure.withAlphaComponent(0.2).setFill()
        return path
    }

    private func getSideRect(between firstDot: Dots, and secondDot: Dots) -> UIBezierPath {

        let centerOfSideRect = CGPoint(x: (dictOfCenters[firstDot]!.x + dictOfCenters[secondDot]!.x) / 2,
                                       y: (dictOfCenters[firstDot]!.y + dictOfCenters[secondDot]!.y) / 2)
        let startPoint = getSidePoint(betweenCenter: centerOfSideRect, andPoint: dictOfCenters[firstDot]!)
        let endPoint = getSidePoint(betweenCenter: centerOfSideRect, andPoint: dictOfCenters[secondDot]!)

        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.close()
        UIColor.azure.setStroke()
        path.lineWidth = 15
        
        return path
    }
    
    private func getSidePoint(betweenCenter center: CGPoint, andPoint anotherPoint: CGPoint) -> CGPoint {
        return CGPoint(x: ((sideDragerLenghtMod * center.x) + anotherPoint.x) / (sideDragerLenghtMod + 1),
                y: ((sideDragerLenghtMod * center.y) + anotherPoint.y) / (sideDragerLenghtMod + 1))
    }
}
