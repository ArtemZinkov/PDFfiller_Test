//
//  ViewController.swift
//  TestUI
//
//  Created by Artem on 13.04.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class ScanToFillViewController: UIViewController {

    private lazy var STF_view = view as! ScanToFillView
    private var touchedDot: Dots?
    private var touchedSide: Sides?
    var dotTouchAccurancy: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(panGR)
        
        // setting dots coordinates
        setStartingSettings()
    }
    
    func setStartingSettings() {
        STF_view.dictOfCenters[.upperLeft] = CGPoint(x: STF_view.bounds.width * 0.1, y: view.bounds.height * 0.1)
        STF_view.dictOfCenters[.upperRight] = CGPoint(x: STF_view.bounds.width * 0.9, y: view.bounds.height * 0.1)
        STF_view.dictOfCenters[.lowerLeft] = CGPoint(x: STF_view.bounds.width * 0.1, y: view.bounds.height * 0.9)
        STF_view.dictOfCenters[.lowerRight] = CGPoint(x: STF_view.bounds.width * 0.9, y: view.bounds.height * 0.9)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            let touchedAt = gesture.location(in: STF_view)
            for keyValue in STF_view.dictOfCenters {
                if sqrt(pow(keyValue.value.x - touchedAt.x, 2) + pow(keyValue.value.y - touchedAt.y, 2)) <= dotTouchAccurancy {
                    touchedDot = keyValue.key
                }
            }
            
            if touchedDot == nil {
                for keyValue in STF_view.dictOfSidesRects {
                    if keyValue.value.contains(touchedAt) {
                        touchedSide = keyValue.key
                    }
                }
            }
            
        case .changed:
            if let touchedDot = touchedDot {
                var changedDict = STF_view.dictOfCenters
                let newCenterForDot = gesture.location(in: STF_view)
                changedDict[touchedDot] = newCenterForDot
                if STF_view.isConvex(touchedDot, changedDict) {
                    STF_view.dictOfCenters[touchedDot] = newCenterForDot
                }
            }
            if let touchedSide = touchedSide {
                let movedBy = gesture.translation(in: STF_view)
                let dots: (first: Dots,second: Dots) = STF_view.dictOfDotsForSides[touchedSide]!
                var changedDict = STF_view.dictOfCenters

                changedDict[dots.first]!.x += movedBy.x
                changedDict[dots.first]!.y += movedBy.y
                changedDict[dots.second]!.x += movedBy.x
                changedDict[dots.second]!.y += movedBy.y

                if STF_view.isConvex(dots.first, changedDict), STF_view.isConvex(dots.second, changedDict) {
                    STF_view.dictOfCenters[dots.first]!.x += movedBy.x
                    STF_view.dictOfCenters[dots.first]!.y += movedBy.y
                    STF_view.dictOfCenters[dots.second]!.x += movedBy.x
                    STF_view.dictOfCenters[dots.second]!.y += movedBy.y
                }

                gesture.setTranslation(CGPoint.zero, in: STF_view)
            }
        case .ended, .cancelled, .failed:
            touchedDot = nil
            touchedSide = nil
        default:
            touchedDot = nil
            touchedSide = nil
        }
    }
}
