//
//  ViewController.swift
//  TestUI
//
//  Created by Artem on 13.04.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class ScanToFillViewController: UIViewController {

    private var STF_view: ScanToFillView!
    private var touchedDot: Dots?
    private var touchedSide: Sides?
    private var touchedRect = false
    var dotTouchAccurancy: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(panGR)
        
        // setting dots coordinates
        STF_view = ScanToFillView(frame: view.frame)
        view.addSubview(STF_view)
        STF_view.backgroundColor = .white
        STF_view.contentMode = .redraw
        STF_view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        STF_view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        STF_view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        STF_view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        STF_view.setStartingSettings()
    }
    
    func initialize(with rect: CGRect) {
        let xMid = (STF_view.bounds.width - rect.width)/2
        let yMid = (STF_view.bounds.height - rect.height)/2
        let upperLeft = CGPoint(x: xMid, y: yMid)
        let upperRight = CGPoint(x: rect.width + xMid, y: yMid)
        let lowerRight = CGPoint(x: rect.width + xMid, y: rect.height + yMid)
        let lowerLeft = CGPoint(x: xMid, y: rect.height + yMid)
        initialize(upperLeft: upperLeft,
                   upperRight: upperRight,
                   lowerRight: lowerRight,
                   lowerLeft: lowerLeft)
    }
    
    func initialize(upperLeft: CGPoint, upperRight: CGPoint, lowerRight: CGPoint, lowerLeft: CGPoint) {
        var dictForCheck = STF_view.dictOfCenters
        dictForCheck[.upperLeft] = upperLeft
        dictForCheck[.upperRight] = upperRight
        dictForCheck[.lowerRight] = lowerRight
        dictForCheck[.lowerLeft] = lowerLeft

        if STF_view.isConvex(with: dictForCheck) {
            STF_view.dictOfCenters[.upperLeft] = upperLeft
            STF_view.dictOfCenters[.upperRight] = upperRight
            STF_view.dictOfCenters[.lowerRight] = lowerRight
            STF_view.dictOfCenters[.lowerLeft] = lowerLeft
        }
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        
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
            
            if STF_view.getMainRectPath().contains(touchedAt) {
                touchedRect = true
            }
            
        case .changed:
            if let touchedDot = touchedDot {
                var changedDict = STF_view.dictOfCenters
                let newCenterForDot = gesture.location(in: STF_view)
                changedDict[touchedDot] = newCenterForDot
                if STF_view.isConvex(with: changedDict) {
                    STF_view.dictOfCenters[touchedDot] = newCenterForDot
                }
            }
            if touchedRect, touchedDot == nil, touchedSide == nil {
                let movedBy = gesture.translation(in: STF_view)
                var changedDict = STF_view.dictOfCenters
                
                for keyValue in changedDict {
                    changedDict[keyValue.key]!.x += movedBy.x
                    changedDict[keyValue.key]!.y += movedBy.y
                }
                STF_view.dictOfCenters = changedDict
            }
            if let touchedSide = touchedSide {
                let movedBy = gesture.translation(in: STF_view)
                let dots: (first: Dots,second: Dots) = STF_view.dictOfDotsForSides[touchedSide]!
                var changedDict = STF_view.dictOfCenters

                changedDict[dots.first]!.x += movedBy.x
                changedDict[dots.first]!.y += movedBy.y
                changedDict[dots.second]!.x += movedBy.x
                changedDict[dots.second]!.y += movedBy.y

                if STF_view.isConvex(with: changedDict) {
                    STF_view.dictOfCenters[dots.first]!.x += movedBy.x
                    STF_view.dictOfCenters[dots.first]!.y += movedBy.y
                    STF_view.dictOfCenters[dots.second]!.x += movedBy.x
                    STF_view.dictOfCenters[dots.second]!.y += movedBy.y
                }

            }

            gesture.setTranslation(CGPoint.zero, in: STF_view)
        case .ended, .cancelled, .failed:
            touchedDot = nil
            touchedSide = nil
            touchedRect = false
        default:
            touchedDot = nil
            touchedSide = nil
            touchedRect = false
        }
    }
}
