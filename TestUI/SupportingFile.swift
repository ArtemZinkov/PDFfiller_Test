//
//  SupportingFile.swift
//  TestUI
//
//  Created by Artem on 21.04.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class checkingFunctions {
    
    static func intersection(ofLineFrom p1: CGPoint, to p2: CGPoint, withLineFrom p3: CGPoint, to p4: CGPoint) -> Bool {
        let d = (p2.x - p1.x)*(p4.y - p3.y) - (p2.y - p1.y)*(p4.x - p3.x)
        if (d == 0) {
            return false // parallel lines
        }
        let u = ((p3.x - p1.x)*(p4.y - p3.y) - (p3.y - p1.y)*(p4.x - p3.x))/d;
        let v = ((p3.x - p1.x)*(p2.y - p1.y) - (p3.y - p1.y)*(p2.x - p1.x))/d;
        if (u < 0.0 || u > 1.0) {
            return false // intersection point not between p1 and p2
        }
        if (v < 0.0 || v > 1.0) {
            return false // intersection point not between p3 and p4
        }
        
        return true //CGPoint(x: p1.x + u * (p2.x - p1.x), y: p1.y + u * (p2.y - p1.y))
    }
    
}

extension UIBezierPath {
    public func addDot(withCenter center: CGPoint) {
        self.addArc(withCenter: center,
                    radius: 10,
                    startAngle: 0,
                    endAngle: 2*CGFloat.pi,
                    clockwise: true)
        self.close()
    }
}

extension UIColor {
    public class var azure: UIColor {
        return UIColor(red: 0, green: 1/2, blue: 5/6, alpha: 1)
    }
}

enum Dots {
    case upperLeft
    case upperRight
    case lowerLeft
    case lowerRight
}

enum Sides {
    case up
    case down
    case left
    case right
}
