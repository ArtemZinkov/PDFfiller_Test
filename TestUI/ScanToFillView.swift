//
//  ViewController.swift
//  TestUI
//
//  Created by Artem on 13.04.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class ScanToFillView: UIView {
    
   var dictOfCenters = [Dots: CGPoint]() { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        drawDot(with: dictOfCenters[.upperLeft]!)
        drawDot(with: dictOfCenters[.upperRight]!)
        drawDot(with: dictOfCenters[.lowerLeft]!)
        drawDot(with: dictOfCenters[.lowerRight]!)
        drawRect()
    }
    
    func drawDot(with center: CGPoint) {
        let path = UIBezierPath()
        path.addDot(withCenter: center)
        UIColor.blue.setFill()
        path.fill()
    }
    
    func drawRect() {
        let path = UIBezierPath()
        path.move(to: dictOfCenters[.upperLeft]!)
        path.addLine(to: dictOfCenters[.upperRight]!)
        path.addLine(to: dictOfCenters[.lowerRight]!)
        path.addLine(to: dictOfCenters[.lowerLeft]!)
        path.close()
        path.lineWidth = 5.0
        UIColor.blue.setStroke()
        UIColor.blue.withAlphaComponent(0.2).setFill()
        path.stroke()
        path.fill()
    }
}

extension UIBezierPath {
    func addDot(withCenter center: CGPoint) {
        self.addArc(withCenter: center,
                    radius: 10,
                    startAngle: 0,
                    endAngle: 2*CGFloat.pi,
                    clockwise: true)
        self.close()
    }
}

enum Dots {
    case upperLeft
    case upperRight
    case lowerLeft
    case lowerRight
}


var arr = [3,4,4,6,1,4,4]
public func solution(_ N : Int, _ A : inout [Int]) -> [Int] {
    
    var arr = Array<Int>(repeating: 0, count: N)
    
    for value in A {
        if value == N + 1 {
            arr = Array<Int>(repeating: arr.max()!, count: N)
        } else {
            arr[value-1] += 1
        }
    }
    return arr
}

//You are given N counters, initially set to 0, and you have two possible operations on them:
//
//increase(X) − counter X is increased by 1,
//max counter − all counters are set to the maximum value of any counter.
//A non-empty zero-indexed array A of M integers is given. This array represents consecutive operations:
//
//    if A[K] = X, such that 1 ≤ X ≤ N, then operation K is increase(X),
//if A[K] = N + 1 then operation K is max counter.
//For example, given integer N = 5 and array A such that:
//
//A[0] = 3
//A[1] = 4
//A[2] = 4
//A[3] = 6
//A[4] = 1
//A[5] = 4
//A[6] = 4
//the values of the counters after each consecutive operation will be:
//
//(0, 0, 1, 0, 0)
//(0, 0, 1, 1, 0)
//(0, 0, 1, 2, 0)
//(2, 2, 2, 2, 2)
//(3, 2, 2, 2, 2)
//(3, 2, 2, 3, 2)
//(3, 2, 2, 4, 2)
//The goal is to calculate the value of every counter after all operations.
//
//Write a function:
//
//public func solution(_ N : Int, _ A : inout [Int]) -> [Int]
//
//that, given an integer N and a non-empty zero-indexed array A consisting of M integers, returns a sequence of integers representing the values of the counters.
//
//The sequence should be returned as an array of integers.
//For example, given:
//
//A[0] = 3
//A[1] = 4
//A[2] = 4
//A[3] = 6
//A[4] = 1
//A[5] = 4
//A[6] = 4
//the function should return [3, 2, 2, 4, 2], as explained above.
//
//Assume that:
//
//N and M are integers within the range [1..100,000];
//each element of array A is an integer within the range [1..N + 1].
//Complexity:
//
//expected worst-case time complexity is O(N+M);
//expected worst-case space complexity is O(N), beyond input storage (not counting the storage required for input arguments).
