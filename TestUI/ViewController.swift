//
//  ViewController.swift
//  TestUI
//
//  Created by Artem on 13.04.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var STF_view = view as! ScanToFillView
    var touchedDot: Dots?

    override func viewDidLoad() {
        super.viewDidLoad()
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(panGR)
        
        // setting dots coordinates
        STF_view.dictOfCenters[.upperLeft] = CGPoint(x: STF_view.bounds.width * 0.1, y: STF_view.bounds.height * 0.1)
        STF_view.dictOfCenters[.upperRight] = CGPoint(x: STF_view.bounds.width * 0.9, y: STF_view.bounds.height * 0.1)
        STF_view.dictOfCenters[.lowerLeft] = CGPoint(x: STF_view.bounds.width * 0.1, y: STF_view.bounds.height * 0.9)
        STF_view.dictOfCenters[.lowerRight] = CGPoint(x: STF_view.bounds.width * 0.9, y: STF_view.bounds.height * 0.9)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            let touchedAt = gesture.location(in: STF_view)
            for keyValue in STF_view.dictOfCenters {
                if sqrt(pow(keyValue.value.x - touchedAt.x, 2) + pow(keyValue.value.y - touchedAt.y, 2)) <= 10 {
                    touchedDot = keyValue.key
                }
            }
        case .changed:
            let movedTo = gesture.location(in: STF_view)
            if let touchedDot = touchedDot {
                STF_view.dictOfCenters[touchedDot] = movedTo
            }
        case .ended, .cancelled, .failed:
            touchedDot = nil
        default:
            touchedDot = nil
        }
    }
}
